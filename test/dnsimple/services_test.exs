defmodule Dnsimple.ServicesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Services
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010
  @domain_id "example.com"

  describe ".applied_services" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/services"
      {:ok, fixture: "appliedServices/success.http", method: "get", url: url}
    end

    test "returns the applied services in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.applied_services(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 1
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Service end)
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
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/services/1"
      method  = "post"
      fixture = "applyService/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.apply_service(@client, @account_id, @domain_id, _service_id = 1)
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
