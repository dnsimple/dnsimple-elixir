defmodule Dnsimple.ClientTest do
  use TestCase, async: false
  doctest Dnsimple.Client

  test "initialize with defaults" do
    client = %Dnsimple.Client{}
    assert client.access_token == nil
    assert client.base_url == "https://api.dnsimple.com"
  end

  describe "when configuration is set" do
    setup do
      Application.put_env(:dnsimple, :access_token, "s3cr35")
      Application.put_env(:dnsimple, :base_url, "https://api.local.dnsimple.test")

      on_exit(fn ->
        Application.delete_env(:dnsimple, :access_token)
        Application.delete_env(:dnsimple, :base_url)
      end)
    end

    test "initialize with configuration" do
      client = Dnsimple.Client.new_from_env()
      assert client.access_token == "s3cr35"
      assert client.base_url == "https://api.local.dnsimple.test"
    end
  end

  describe ".versioned" do
    test "joins path with current api version" do
      assert Dnsimple.Client.versioned("/whoami") == "/v2/whoami"
    end
  end

  describe ".execute" do
    setup do
      bypass = Bypass.open()

      client = %Dnsimple.Client{
        access_token: "i-am-a-token",
        base_url: "http://localhost:#{bypass.port}"
      }

      {:ok, bypass: bypass, client: client}
    end

    test "handles headers defines as a map", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/1010/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listDomains/success.http")
      end)

      {:ok, response} = Dnsimple.Domains.list_domains(client, "1010", headers: %{page: 2})
      assert response.__struct__ == Dnsimple.Response
    end

    test "handles headers defines as a list", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/1010/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listDomains/success.http")
      end)

      {:ok, response} =
        Dnsimple.Domains.list_domains(client, "1010", headers: [{"X-Header", "X-Value"}])

      assert response.__struct__ == Dnsimple.Response
    end

    test "returns a NotFoundError when the response has a 404 status code", %{
      bypass: bypass,
      client: client
    } do
      domain_id = 0

      Bypass.expect_once(bypass, "GET", "/v2/1010/domains/#{domain_id}", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "notfound-domain.http")
      end)

      {:error, response} = Dnsimple.Domains.get_domain(client, "1010", domain_id)
      assert response.__struct__ == Dnsimple.NotFoundError
      assert response.message == "Domain `0` not found"
    end

    test "returns a ResponseError when the response has a 4XX status code (other than 404)", %{
      bypass: bypass,
      client: client
    } do
      domain_id = "example.com"

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/1010/registrar/domains/#{domain_id}/renewals",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "renewDomain/error-tooearly.http")
        end
      )

      {:error, response} = Dnsimple.Registrar.renew_domain(client, "1010", domain_id)
      assert response.__struct__ == Dnsimple.RequestError
      assert response.message == "HTTP 400: example.com may not be renewed at this time"
      assert response.attribute_errors == %{}
    end

    test "returns a ResponseError when the response has a 4XX status code (other than 404) with attribute-specific errors",
         %{bypass: bypass, client: client} do
      attributes = %{}

      Bypass.expect_once(bypass, "POST", "/v2/1010/contacts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "validation-error.http")
      end)

      {:error, response} = Dnsimple.Contacts.create_contact(client, "1010", attributes)
      assert response.__struct__ == Dnsimple.RequestError
      assert response.message == "HTTP 400: Validation failed"

      assert response.attribute_errors == %{
               "address1" => ["can't be blank"],
               "city" => ["can't be blank"],
               "country" => ["can't be blank"],
               "email" => ["can't be blank", "is an invalid email address"],
               "first_name" => ["can't be blank"],
               "last_name" => ["can't be blank"],
               "phone" => ["can't be blank", "is probably not a phone number"],
               "postal_code" => ["can't be blank"],
               "state_province" => ["can't be blank"]
             }
    end

    test "returns a ResponseError when the response has a 5XX status code", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "GET", "/v2/1010/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "badgateway.http")
      end)

      {:error, response} = Dnsimple.Domains.list_domains(client, "1010")
      assert response.__struct__ == Dnsimple.RequestError

      assert response.message ==
               "HTTP 502: <html>\n<head><title>502 Bad Gateway</title></head>\n<body bgcolor=\"white\">\n<center><h1>502 Bad Gateway</h1></center>\n<hr><center>nginx</center>\n</body>\n</html>\n"

      assert response.attribute_errors == nil
    end
  end
end

defmodule Dnsimple.ListingTest do
  use TestCase, async: false

  alias Dnsimple.Listing

  describe ".format" do
    test "empty list options results in empty params list" do
      assert Listing.format([]) == []
    end

    test "empty list options with other options results in no params list" do
      assert Listing.format(headers: [{"X-Header", "X-Value"}]) == [
               headers: [{"X-Header", "X-Value"}]
             ]
    end

    test "includes filter if present" do
      assert Listing.format(filter: [name_like: "example"]) == [params: [name_like: "example"]]
    end

    test "includes sort if it present" do
      assert Listing.format(sort: "foo:asc") == [params: [sort: "foo:asc"]]
    end

    test "includes page if it present" do
      assert Listing.format(page: 1) == [params: [page: 1]]
    end

    test "includes per page if present" do
      assert Listing.format(per_page: 1) == [params: [per_page: 1]]
    end

    test "combines options correctly" do
      assert Listing.format(per_page: 1, sort: "foo:asc") == [
               params: [per_page: 1, sort: "foo:asc"]
             ]
    end

    test "maintains other options" do
      assert Listing.format(sort: "foo:asc", other: "foo") == [
               params: [sort: "foo:asc"],
               other: "foo"
             ]
    end
  end

  describe ".get_all" do
    setup do
      bypass = Bypass.open()

      client = %Dnsimple.Client{
        access_token: "i-am-a-token",
        base_url: "http://localhost:#{bypass.port}"
      }

      {:ok, bypass: bypass, client: client, account_id: 1010}
    end

    test "returns the resources of all pages", %{
      bypass: bypass,
      client: client,
      account_id: account_id
    } do
      page1 =
        ~s({"data":[{"id":1,"account_id":1010,"registrant_id":null,"name":"example-alpha.com","unicode_name":"example-alpha.com","token":"domain-token","state":"hosted","auto_renew":false,"private_whois":false,"expires_on":null,"created_at":"2014-12-06T15:56:55.573Z","updated_at":"2015-12-09T00:20:56.056Z"}],"pagination":{"current_page":1,"per_page":1,"total_entries":2,"total_pages":2}})

      page2 =
        ~s({"data":[{"id":2,"account_id":1010,"registrant_id":21,"name":"example-beta.com","unicode_name":"example-beta.com","token":"domain-token","state":"registered","auto_renew":false,"private_whois":false,"expires_on":"2015-12-06","created_at":"2014-12-06T15:46:52.411Z","updated_at":"2015-12-09T00:20:53.572Z"}],"pagination":{"current_page":2,"per_page":1,"total_entries":2,"total_pages":2}})

      Bypass.expect(bypass, "GET", "/v2/#{account_id}/domains", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        body = if conn.query_params["page"] == "2", do: page2, else: page1

        conn
        |> Plug.Conn.put_resp_header("x-ratelimit-limit", "1000")
        |> Plug.Conn.put_resp_header("x-ratelimit-remaining", "999")
        |> Plug.Conn.put_resp_header("x-ratelimit-reset", "1450272970")
        |> Plug.Conn.resp(200, body)
      end)

      {:ok, domains} =
        Listing.get_all(Dnsimple.Domains, :list_domains, [client, account_id, []])

      assert is_list(domains)
      assert length(domains) == 2
      assert Enum.all?(domains, fn single -> single.__struct__ == Dnsimple.Domain end)
    end

    test "returns the resources of all pages respecting options", %{
      bypass: bypass,
      client: client,
      account_id: account_id
    } do
      page1 =
        ~s({"data":[{"id":1,"account_id":1010,"registrant_id":null,"name":"example-alpha.com","unicode_name":"example-alpha.com","token":"domain-token","state":"hosted","auto_renew":false,"private_whois":false,"expires_on":null,"created_at":"2014-12-06T15:56:55.573Z","updated_at":"2015-12-09T00:20:56.056Z"}],"pagination":{"current_page":1,"per_page":1,"total_entries":2,"total_pages":2}})

      page2 =
        ~s({"data":[{"id":2,"account_id":1010,"registrant_id":21,"name":"example-beta.com","unicode_name":"example-beta.com","token":"domain-token","state":"registered","auto_renew":false,"private_whois":false,"expires_on":"2015-12-06","created_at":"2014-12-06T15:46:52.411Z","updated_at":"2015-12-09T00:20:53.572Z"}],"pagination":{"current_page":2,"per_page":1,"total_entries":2,"total_pages":2}})

      Bypass.expect(bypass, "GET", "/v2/#{account_id}/domains", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        body = if conn.query_params["page"] == "2", do: page2, else: page1

        conn
        |> Plug.Conn.put_resp_header("x-ratelimit-limit", "1000")
        |> Plug.Conn.put_resp_header("x-ratelimit-remaining", "999")
        |> Plug.Conn.put_resp_header("x-ratelimit-reset", "1450272970")
        |> Plug.Conn.resp(200, body)
      end)

      {:ok, domains} =
        Listing.get_all(Dnsimple.Domains, :list_domains, [client, account_id, [sort: "id:asc"]])

      assert is_list(domains)
      assert length(domains) == 2
      assert Enum.all?(domains, fn single -> single.__struct__ == Dnsimple.Domain end)
    end
  end
end
