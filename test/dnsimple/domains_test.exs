defmodule Dnsimple.DomainsTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Domains
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes", "test/fixtures/custom_cassettes")
    :ok
  end

  describe ".domains" do
    test "returns the domains in a Dnsimple.Response" do
      url = "#{@client.base_url}/v2/1010/domains"
      use_cassette :stub, ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url) do
        {:ok, response} = @module.domains(@client, "1010")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Domain end)
        assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
      end
    end

    test "sends custom headers" do
      url = "#{@client.base_url}/v2/1010/domains"

      use_cassette :stub, ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url) do
        @module.list_domains(@client, "1010", [headers: %{"X-Header" => "X-Value"}])
      end
    end

    test "supports sorting" do
      url = "#{@client.base_url}/v2/1010/domains?sort=id%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url) do
        @module.list_domains(@client, "1010", [sort: "id:desc"])
      end
    end

    test "supports filtering" do
      url = "#{@client.base_url}/v2/1010/domains?name_like=example"

      use_cassette :stub, ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url) do
        @module.list_domains(@client, "1010", [filter: [name_like: "example"]])
      end
    end

    test "can be called using the alias .domains" do
      url = "#{@client.base_url}/v2/1010/domains"

      use_cassette :stub, ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url) do
        @module.domains(@client, "1010")
      end
    end
  end


  test ".all_domains" do
    use_cassette "list_domains_paginated", custom: true do
      domains = @module.all_domains(@client, "1010")
      assert is_list(domains)
      assert length(domains) == 2
      assert Enum.all?(domains, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      assert Enum.all?(domains, fn(single) -> is_integer(single.id) end)
    end
  end

  describe ".create_domain" do
    test "builds the correct request" do
      fixture = ExvcrUtils.response_fixture("createDomain/created.http", [method: "post", url: @client.base_url <> "/v2/1010/domains", request_body: ~s'{"name":"example.com"}'])
      use_cassette :stub, fixture do
        @module.create_domain(@client, "1010", %{name: "example.com"})
      end
    end

    test "returns a Dnsimple.Response" do
      fixture = ExvcrUtils.response_fixture("createDomain/created.http", [method: "post", request_body: ""])
      use_cassette :stub, fixture do
        {:ok, response} = @module.create_domain(@client, "1010", "")
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
        @module.domain(@client, "1010", "example.weppos")
      end
    end

    test "returns a Dnsimple.Response" do
      use_cassette :stub, ExvcrUtils.response_fixture("getDomain/success.http", [method: "get"]) do
        {:ok, response} = @module.domain(@client, "_", "example.weppos")
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
        @module.delete_domain(@client, "1010", "example.weppos")
      end
    end

    test "returns a Dnsimple.Response" do
      use_cassette :stub, ExvcrUtils.response_fixture("deleteDomain/success.http", [method: "delete"]) do
        {:ok, response} = @module.delete_domain(@client, "_", "example.weppos")
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

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.reset_domain_token(@client, "1010", "example.com")

        assert response.data.__struct__ == Dnsimple.Domain
      end
    end
  end

end
