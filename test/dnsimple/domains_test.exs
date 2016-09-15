defmodule Dnsimple.DomainsTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Domains
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes", "test/fixtures/custom_cassettes")
    :ok
  end

  describe ".domains" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains"
      {:ok, fixture: "listDomains/success.http", method: "get", url: url}
    end

    test "returns the domains in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.domains(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/domains?sort=id%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id, sort: "id:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/domains?name_like=example"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id, filter: [name_like: "example"])
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .domains", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.domains(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  test ".all_domains" do
    use_cassette "list_domains_paginated", custom: true do
      domains = @module.all_domains(@client, @account_id)
      assert is_list(domains)
      assert length(domains) == 2
      assert Enum.all?(domains, fn(single) -> single.__struct__ == Dnsimple.Domain end)
    end
  end


  describe ".get_domain" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/example-alpha.com"
      {:ok, fixture: "getDomain/success.http", method: "get", url: url}
    end

    test "builds the correct request", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.domain(@client, @account_id, "example-alpha.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Domain
        assert data.id == 1
        assert data.name == "example-alpha.com"
      end
    end

    test "can be called using the alias .domain", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain(@client, @account_id, "example-alpha.com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_domain" do
    test "creates the domain and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains"
      method     = "post"
      fixture    = "createDomain/created.http"
      attributes = %{name: "example-alpha.com"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_domain(@client, @account_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Domain
        assert data.id == 1
        assert data.name == "example-alpha.com"
      end
    end
  end


  describe ".delete_domain" do
    test "deletes the domain and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/example.org"
      method  = "delete"
      fixture = "deleteDomain/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_domain(@client, @account_id, _domain_id = "example.org")
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe "reset_domain_token" do
    test "returns a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/domains/example.com/token"
      method      = "post"
      fixture     = "resetDomainToken/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.reset_domain_token(@client, @account_id, _domain_id = "example.com")
        assert response.__struct__ == Dnsimple.Response
        assert response.data.__struct__ == Dnsimple.Domain
      end
    end
  end

end
