defmodule DnsimpleZonesServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.ZonesService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  test ".list_zones" do
    fixture = "listZones/success.http"
    method  = "get"
    url     = "#{@client.base_url}/v2/#{@account_id}/zones"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.list_zones(@client, @account_id)

      assert response.__struct__ == Dnsimple.Response
      assert Enum.count(response.data) == 2
      assert Enum.all?(response.data, fn(item) -> item.__struct__ == Dnsimple.Zone end)
    end
  end

end
