defmodule Dnsimple.ResponseTest do
  use TestCase, async: false
  doctest Dnsimple.Response

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "x",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".parse" do
    test "extracts the response body into structs WITH a data attribute", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "GET", "/v2/1010/domains/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getDomain/success.http")
      end)

      http_response = Dnsimple.Client.execute(client, "get", "/v2/1010/domains/1")
      {:ok, response} = Dnsimple.Response.parse(http_response, %{"data" => %Dnsimple.Domain{}})

      assert response.data.__struct__ == Dnsimple.Domain
    end

    test "extracts the response body into NESTED structs WITH a data attribute", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "GET", "/v2/tlds/com/extended_attributes", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getTldExtendedAttributes/success.http")
      end)

      http_response =
        Dnsimple.Client.execute(client, "get", "/v2/tlds/com/extended_attributes")

      {:ok, response} =
        Dnsimple.Response.parse(http_response, %{
          "data" => [
            %Dnsimple.TldExtendedAttribute{options: [%Dnsimple.TldExtendedAttribute.Option{}]}
          ]
        })

      [attribute | _] = response.data
      assert attribute.__struct__ == Dnsimple.TldExtendedAttribute

      [option | _] = attribute.options
      assert option.__struct__ == Dnsimple.TldExtendedAttribute.Option
    end

    test "extracts the response body into structs WITHOUT a data attribute", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "POST", "/oauth/access_token", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "oauthAccessToken/success.http")
      end)

      http_response = Dnsimple.Client.execute(client, "post", "/oauth/access_token")
      {:ok, response} = Dnsimple.Response.parse(http_response, %Dnsimple.OauthToken{})

      assert response.data.__struct__ == Dnsimple.OauthToken
    end

    test "parses a response without extracting data", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "DELETE", "/path", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "deleteDomain/success.http")
      end)

      http_response = {:ok, http} = Dnsimple.Client.execute(client, "delete", "/path")
      {:ok, response} = Dnsimple.Response.parse(http_response, nil)

      assert response.http_response == http
      assert response.data == nil
    end

    test "parses the rate-limit", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/path", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "whoami/success.http")
      end)

      http_response = Dnsimple.Client.execute(client, "get", "/path")
      {:ok, response} = Dnsimple.Response.parse(http_response, nil)

      assert response.rate_limit == 4000
      assert response.rate_limit_remaining == 3991
      assert response.rate_limit_reset == 1_450_451_976
    end

    test "parses pagination", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/path", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "pages-1of3.http")
      end)

      http_response = Dnsimple.Client.execute(client, "get", "/path")

      {:ok, response} =
        Dnsimple.Response.parse(http_response, %{
          "data" => [%Dnsimple.Domain{}],
          "pagination" => %Dnsimple.Response.Pagination{}
        })

      assert response.data != nil

      assert response.pagination != nil
      assert response.pagination.current_page == 1
      assert response.pagination.per_page == 2
      assert response.pagination.total_pages == 3
      assert response.pagination.total_entries == 5
    end
  end
end
