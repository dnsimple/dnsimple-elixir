defmodule DnsimpleZonesServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.ZonesService

  @service Dnsimple.ZonesService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test/"}


  test ".zone/3 builds the correct request" do
    fixture = ExvcrUtils.response_fixture("getZone/success.http", [url: @client.base_url <> "v2/_/zones/example.weppos"])
    use_cassette :stub, fixture do
      @service.zone(@client, "example.weppos")
    end
  end

  test ".zone/4 builds the correct request" do
    fixture = ExvcrUtils.response_fixture("getZone/success.http", [url: @client.base_url <> "v2/1010/zones/example.weppos"])
    use_cassette :stub, fixture do
      @service.zone(@client, 1010, "example.weppos", [])
    end
  end

  test ".zone returns a Dnsimple.Zone" do
    use_cassette :stub, ExvcrUtils.response_fixture("getZone/success.http", [url: "~r/\/zones/.+$/"]) do
      response = @service.zone(@client, "example.weppos")
      assert is_map(response)
      assert response.__struct__ == Dnsimple.Zone
      assert response.id == 1
      assert response.name == "example.com"
    end
  end


end

