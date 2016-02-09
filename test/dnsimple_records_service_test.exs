defmodule DnsimpleRecordsServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.RecordsService

  @service Dnsimple.RecordsService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test/"}


  test ".records builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listZoneRecords/success.http", [url: @client.base_url <> "v2/1010/zones/example.com/records"])
    use_cassette :stub, fixture do
      @service.records(@client, 1010, "example.com", [])
    end
  end

  test ".records returns a list of Dnsimple.Record" do
    use_cassette :stub, ExvcrUtils.response_fixture("listZoneRecords/success.http", [url: "~r/\/records$/"]) do
      response = @service.records(@client, 1010, "example.com", [])
      assert is_list(response)
      assert length(response) == 7
      assert Enum.all?(response, fn(single) -> single.__struct__ == Dnsimple.Record end)
      assert Enum.all?(response, fn(single) -> is_integer(single.id) end)
    end
  end

  test ".record builds the correct request" do
    fixture = ExvcrUtils.response_fixture("getZoneRecord/success.http", [url: @client.base_url <> "v2/_/zones/example.weppos/records/1234"])
    use_cassette :stub, fixture do
      @service.record(@client, "example.weppos", 1234)
    end
  end

  test ".records returns a Dnsimple.Record " do
    use_cassette :stub, ExvcrUtils.response_fixture("getZoneRecord/success.http", [url: "~r/\/records/.+$/"]) do
      response = @service.record(@client, "example.weppos", 1)
      assert is_map(response)
      assert response.__struct__ == Dnsimple.Record
      assert response.id == 1
      assert response.type == "ALIAS"
      assert response.content == "example-alias.com"
    end
  end
end

