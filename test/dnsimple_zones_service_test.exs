defmodule DnsimpleZonesServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.ZonesService

  @service Dnsimple.ZonesService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test/"}


  test ".zones/2 builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listZones/success.http", [url: @client.base_url <> "v2/_/zones"])
    use_cassette :stub, fixture do
      @service.zones(@client)
    end
  end

  test ".zones/3 builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listZones/success.http", [url: @client.base_url <> "v2/1010/zones"])
    use_cassette :stub, fixture do
      @service.zones(@client, 1010, [])
    end
  end

  test ".zones returns a list of Dnsimple.Zone" do
    use_cassette :stub, ExvcrUtils.response_fixture("listZones/success.http", [url: "~r/\/zones$/"]) do
      response = @service.zones(@client, 1010, [])
      assert is_list(response)
      assert length(response) == 2
      assert Enum.all?(response, fn(single) -> single.__struct__ == Dnsimple.Zone end)
      assert Enum.all?(response, fn(single) -> is_integer(single.id) end)
    end
  end

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

