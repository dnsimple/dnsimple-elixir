defmodule Dnsimple.ResponseTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Response

  @client %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}

  describe ".parse" do
    test "extracts the response body into structs WITH a data attribute" do
      use_cassette :stub, ExvcrUtils.response_fixture("getDomain/success.http", method: "get") do
        http_response   = Dnsimple.Client.execute(@client, "get", "/v2/1010/domains/1")
        {:ok, response} = Dnsimple.Response.parse(http_response, %Dnsimple.Domain{})

        assert response.data.__struct__ == Dnsimple.Domain
      end
    end

    @tag :skip
    test "extracts the response body into NESTED structs WITH a data attribute" do
      use_cassette :stub, ExvcrUtils.response_fixture("getTldExtendedAttributes/success.http", method: "get") do
        http_response   = Dnsimple.Client.execute(@client, "get", "/v2/tlds/com/extended_attributes")
        {:ok, response} = Dnsimple.Response.parse(http_response, %Dnsimple.TldExtendedAttribute{})

        [attribute | _] = response.data
        assert attribute.__struct__ == Dnsimple.TldExtendedAttribute

        [option | _] = attribute.options
        assert option.__struct__ == Dnsimple.TldExtendedAttribute.Option
      end
    end

    test "extracts the response body into structs WITHOUT a data attribute" do
      use_cassette :stub, ExvcrUtils.response_fixture("oauthAccessToken/success.http", method: "post") do
        http_response   = Dnsimple.Client.execute(@client, "post", "/oauth/access_token")
        {:ok, response} = Dnsimple.Response.parse(http_response, %Dnsimple.OauthToken{})

        assert response.data.__struct__ == Dnsimple.OauthToken
      end
    end

    test "parses a response without extracting data" do
      use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", method: "get") do
        http_response = {:ok, http} = Dnsimple.Client.execute(@client, "get", "/path")
        {:ok, response} = Dnsimple.Response.parse(http_response, nil)

        assert response.http_response == http
        assert response.data == nil
      end
    end

    test "parses the rate-limit" do
      use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", method: "get") do
        http_response = Dnsimple.Client.execute(@client, "get", "/path")
        {:ok, response} = Dnsimple.Response.parse(http_response, nil)

        assert response.rate_limit == 4000
        assert response.rate_limit_remaining == 3991
        assert response.rate_limit_reset == 1450451976
      end
    end

    test "parses pagination" do
      use_cassette :stub, ExvcrUtils.response_fixture("pages1of3.http", method: "get") do
        http_response = Dnsimple.Client.execute(@client, "get", "/path")
        {:ok, response} = Dnsimple.Response.parse(http_response, nil)

        assert response.pagination != nil
        assert response.pagination.current_page == 1
        assert response.pagination.per_page == 2
        assert response.pagination.total_pages == 3
        assert response.pagination.total_entries == 5
      end
    end
  end

end
