defmodule Dnsimple.ClientTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Client

  test "initialize with defaults" do
    client = %Dnsimple.Client{}
    assert client.access_token == nil
    assert client.base_url == "https://api.dnsimple.com"
  end


  describe ".versioned" do
    test "joins path with current api version" do
      assert Dnsimple.Client.versioned("/whoami") == "/v2/whoami"
    end
  end

  describe ".execute" do
    setup do
      client  = %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
      {:ok, client: client}
    end

    test "handles headers defines as a map", %{client: client} do
      url     = "#{client.base_url}/v2/1010/domains"
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url)
      use_cassette :stub, fixture  do
        {:ok, response} = Dnsimple.Domains.list_domains(client, "1010", headers: %{page: 2})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "handles headers defines as a list", %{client: client} do
      url     = "#{client.base_url}/v2/1010/domains"
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url)
      use_cassette :stub, fixture  do
        {:ok, response} = Dnsimple.Domains.list_domains(client, "1010", headers: [{"X-Header", "X-Value"}])
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "returns a NotFoundError when the response has a 404 status code", %{client: client} do
      domain_id = 0
      url       = "#{client.base_url}/v2/1010/domains/#{domain_id}"
      fixture   = ExvcrUtils.response_fixture("notfound-domain.http", method: "get", url: url)
      use_cassette :stub, fixture  do
        {:error, response} = Dnsimple.Domains.get_domain(client, "1010", domain_id)
        assert response.__struct__ == Dnsimple.NotFoundError
        assert response.message == "Domain `0` not found"
      end
    end

    test "returns a ResponseError when the response has a 4XX status code (other than 404)", %{client: client} do
      domain_id  = "example.com"
      url        = "#{client.base_url}/v2/1010/registrar/domains/#{domain_id}/whois_privacy/renewals"
      fixture    = ExvcrUtils.response_fixture("renewWhoisPrivacy/whois-privacy-duplicated-order.http", method: "post", url: url)
      use_cassette :stub, fixture  do
        {:error, response} = Dnsimple.Registrar.renew_whois_privacy(client, "1010", domain_id)
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 400: The whois privacy for example.com has just been renewed, a new renewal cannot be started at this time"
        assert response.errors == nil
      end
    end

    test "returns a ResponseError when the response has a 4XX status code (other than 404) with attribute-specific errors", %{client: client} do
      attributes = %{}
      url        = "#{client.base_url}/v2/1010/contacts"
      fixture    = ExvcrUtils.response_fixture("validation-error.http", method: "post", url: url)
      use_cassette :stub, fixture  do
        {:error, response} = Dnsimple.Contacts.create_contact(client, "1010", attributes)
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 400: Validation failed"
        assert response.errors == %{
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
    end

    test "returns a ResponseError when the response has a 5XX status code", %{client: client} do
      url        = "#{client.base_url}/v2/1010/domains"
      fixture    = ExvcrUtils.response_fixture("badgateway.http", method: "get", url: url)
      use_cassette :stub, fixture  do
        {:error, response} = Dnsimple.Domains.list_domains(client, "1010")
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 502: <html>\n<head><title>502 Bad Gateway</title></head>\n<body bgcolor=\"white\">\n<center><h1>502 Bad Gateway</h1></center>\n<hr><center>nginx</center>\n</body>\n</html>\n"
        assert response.errors == nil
      end
    end
  end

end

defmodule Dnsimple.ListingTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Dnsimple.Listing

  describe ".format" do
    test "empty list options results in empty params list" do
      assert Listing.format([]) == []
    end

    test "empty list options with other options results in no params list" do
      assert Listing.format([headers: [{"X-Header", "X-Value"}]]) == [headers: [{"X-Header", "X-Value"}]]
    end

    test "includes filter if present" do
      assert Listing.format([filter: [name_like: "example"]]) == [params: [name_like: "example"]]
    end

    test "includes sort if it present" do
      assert Listing.format([sort: "foo:asc"]) == [params: [sort: "foo:asc"]]
    end

    test "includes page if it present" do
      assert Listing.format([page: 1]) == [params: [page: 1]]
    end

    test "includes per page if present" do
      assert Listing.format([per_page: 1]) == [params: [per_page: 1]]
    end

    test "combines options correctly" do
      assert Listing.format([per_page: 1, sort: "foo:asc"]) == [params: [per_page: 1, sort: "foo:asc"]]
    end

    test "maintains other options" do
      assert Listing.format([sort: "foo:asc", other: "foo"]) == [params: [sort: "foo:asc"], other: "foo"]
    end
  end

  describe ".get_all" do
    setup do
      ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes", "test/fixtures/custom_cassettes")
      client = %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
      {:ok, client: client, account_id: 1010}
    end

    test "returns the resources of all pages", %{client: client, account_id: account_id} do
      use_cassette "list_domains_paginated", custom: true do
        {:ok, domains} = Listing.get_all(Dnsimple.Domains, :list_domains, [client, account_id, []])

        assert is_list(domains)
        assert length(domains) == 2
        assert Enum.all?(domains, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      end
    end

    test "returns the resources of all pages respecting options", %{client: client, account_id: account_id} do
      use_cassette "list_domains_paginated_sorted", custom: true do
        {:ok, domains} = Listing.get_all(Dnsimple.Domains, :list_domains, [client, account_id, [sort: "id:asc"]])

        assert is_list(domains)
        assert length(domains) == 2
        assert Enum.all?(domains, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      end
    end
  end

end
