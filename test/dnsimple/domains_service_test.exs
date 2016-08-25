defmodule Dnsimple.DomainsServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.DomainsService

  @service Dnsimple.DomainsService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  describe ".domains" do
    test "builds the correct request" do
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains"])
      use_cassette :stub, fixture do
        @service.domains(@client, "1010")
      end
    end

    test "sends custom headers" do
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains"])
      use_cassette :stub, fixture do
        @service.domains(@client, "1010", [headers: %{"X-Header" => "X-Value"}])
      end
    end

    test "supports sorting" do
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains?sort=id%3Adesc"])
      use_cassette :stub, fixture do
        @service.domains(@client, "1010", [sort: "id:desc"])
      end
    end

    test "supports filtering" do
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains?name_like=example"])
      use_cassette :stub, fixture do
        @service.domains(@client, "1010", [filter: [name_like: "example"]])
      end
    end

    test "returns a list of Dnsimple.Response" do
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get"])
      use_cassette :stub, fixture do
        { :ok, response } = @service.domains(@client, "1010")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Domain end)
        assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
      end
    end
  end


  describe ".create_domain" do
    test "builds the correct request" do
      fixture = ExvcrUtils.response_fixture("createDomain/created.http", [method: "post", url: @client.base_url <> "/v2/1010/domains", request_body: ~s'{"name":"example.com"}'])
      use_cassette :stub, fixture do
        @service.create_domain(@client, "1010", %{ name: "example.com" })
      end
    end

    test "returns a Dnsimple.Response" do
      fixture = ExvcrUtils.response_fixture("createDomain/created.http", [method: "post", request_body: ""])
      use_cassette :stub, fixture do
        { :ok, response } = @service.create_domain(@client, "1010", "")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_map(data)
        assert data.__struct__ == Dnsimple.Domain
        assert data.id == 1
        assert data.name == "example-alpha.com"
      end
    end
  end


  describe ".domain" do
    test "builds the correct request" do
      fixture = ExvcrUtils.response_fixture("getDomain/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.weppos"])
      use_cassette :stub, fixture do
        @service.domain(@client, "1010", "example.weppos")
      end
    end

    test "returns a Dnsimple.Response" do
      use_cassette :stub, ExvcrUtils.response_fixture("getDomain/success.http", [method: "get"]) do
        { :ok, response } = @service.domain(@client, "_", "example.weppos")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_map(data)
        assert data.__struct__ == Dnsimple.Domain
        assert data.id == 1
        assert data.name == "example-alpha.com"
      end
    end
  end


  describe ".delete_domain" do
    test "builds the correct request" do
      fixture = ExvcrUtils.response_fixture("deleteDomain/success.http", [method: "delete", url: @client.base_url <> "/v2/1010/domains/example.weppos"])
      use_cassette :stub, fixture do
        @service.delete_domain(@client, "1010", "example.weppos")
      end
    end

    test "returns a Dnsimple.Response" do
      use_cassette :stub, ExvcrUtils.response_fixture("deleteDomain/success.http", [method: "delete"]) do
        { :ok, response } = @service.delete_domain(@client, "_", "example.weppos")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_nil(data)
      end
    end
  end

  describe "reset_domain_token" do
    test "returns a Dnsimple.Response" do
      fixture     = "resetDomainToken/success.http"
      method      = "post"
      url         = "#{@client.base_url}/v2/1010/domains/example.com/token"
      {:ok, body} = Poison.encode([])

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @service.reset_domain_token(@client, "1010", "example.com")

        assert response.data.__struct__ == Dnsimple.Domain
      end
    end
  end

end
