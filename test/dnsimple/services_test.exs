defmodule Dnsimple.ServicesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Services
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  describe ".list_services" do
    setup do
      url = "#{@client.base_url}/v2/services"
      {:ok, fixture: "listServices/success.http", method: "get", url: url}
    end

    test "returns the services in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_services(@client)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Service end)
      end
    end

    test "correctly parses the service's Settings", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_services(@client)

        [_, service] = response.data
        settings = service.settings
        assert is_list(settings)
        assert Enum.all?(settings, fn(single) -> single.__struct__ == Dnsimple.Service.Setting end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_services(@client)
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/services?sort=short_name%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_services(@client, sort: "short_name:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_service" do
    test "returns the service in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/services/1"
      method  = "get"
      fixture = "getService/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.get_service(@client, _service_id = 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Service
        assert data.id == 1
        assert data.sid == "service1"
        assert data.name == "Service 1"
        assert data.description == "First service example."
        assert data.setup_description == nil
        assert data.requires_setup == true
        assert data.default_subdomain == nil
        assert data.settings == [%Dnsimple.Service.Setting{append: ".service1.com", description: "Your Service 1 username is used to connect services to your account.", example: "username", label: "Service 1 Account Username", name: "username", password: false}]
        assert data.created_at == "2014-02-14T19:15:19Z"
        assert data.updated_at == "2016-03-04T09:23:27Z"
      end
    end
  end


  @account_id 1010
  @domain_id "example.com"


  describe ".applied_services" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/services"
      {:ok, fixture: "appliedServices/success.http", method: "get", url: url}
    end

    test "returns applied services in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.applied_services(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 1
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Service end)
      end
    end

    test "correctly parses the applied service's Settings", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.applied_services(@client, @account_id, @domain_id)

        [service | _] = response.data
        settings = service.settings
        assert is_list(settings)
        assert Enum.all?(settings, fn(single) -> single.__struct__ == Dnsimple.Service.Setting end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.applied_services(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".apply_service" do
    test "applies the service and returns an empty Dnsimple.Response" do
      url      = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/services/1"
      method   = "post"
      fixture  = "applyService/success.http"
      settings = %{settings: %{name: "value"}}
      body     = Poison.encode!(settings)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.apply_service(@client, @account_id, @domain_id, _service_id = 1, settings)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".unapply_service" do
    test "un-applies the service and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/services/1"
      method  = "delete"
      fixture = "applyService/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.unapply_service(@client, @account_id, @domain_id, _service_id = 1)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end

end
