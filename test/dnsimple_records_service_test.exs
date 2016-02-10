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


  test ".create builds the correct request" do
    r = %Dnsimple.Record{name: "alpha", content: "some-text-content", type: "TXT", ttl: 600}
    rb = Dnsimple.Record.to_json(r)
    fixture = ExvcrUtils.response_fixture("createZoneRecord/success.http", [url: @client.base_url <> "v2/1010/zones/example.weppos/records", method: :post, request_body: rb])
    use_cassette :stub, fixture do
      @service.create(@client, 1010, "example.weppos", r, [])
    end
  end

  test ".create returns a Dnsimple.Record " do
    r = %Dnsimple.Record{name: "alpha", content: "some-text-content", type: "TXT", ttl: 600}
    rb = Dnsimple.Record.to_json(r)
    fixture = ExvcrUtils.response_fixture("createZoneRecord/success.http", [url: @client.base_url <> "v2/1010/zones/example.weppos/records", method: :post, request_body: rb])
    use_cassette :stub, fixture do
      response = @service.create(@client, 1010, "example.weppos", r, [])
      assert is_map(response)
      assert response.__struct__ == Dnsimple.Record
      assert response.id == 2
      assert response.type == "TXT"
      assert response.content == "some-text-content"
    end
  end

  test ".update builds the correct request" do
    r = %Dnsimple.Record{id: 2, name: "subdomain", content: "altered-text-content", type: "TXT", ttl: 600}
    rb = Dnsimple.Record.to_json(r)
    fixture = ExvcrUtils.response_fixture("updateZoneRecord/success.http", [url: @client.base_url <> "v2/1010/zones/example.weppos/records/2", method: :patch, request_body: rb])
    use_cassette :stub, fixture do
      @service.update(@client, 1010, "example.weppos", r, [])
    end
  end

  test ".update returns a Dnsimple.Record " do
    r = %Dnsimple.Record{id: 2, name: "subdomain", content: "altered-text-content", type: "TXT", ttl: 600}
    rb = Dnsimple.Record.to_json(r)
    fixture = ExvcrUtils.response_fixture("updateZoneRecord/success.http", [url: @client.base_url <> "v2/1010/zones/example.weppos/records/2", method: :patch, request_body: rb])
    use_cassette :stub, fixture do
      response = @service.update(@client, 1010, "example.weppos", r, [])
      assert is_map(response)
      assert response.__struct__ == Dnsimple.Record
      assert response.id == 2
      assert response.type == "TXT"
      assert response.content == "altered-text-content"
    end
  end

  test ".delete builds the correct request" do
    r = %Dnsimple.Record{id: 2, name: "subdomain", content: "altered-text-content", type: "TXT", ttl: 600}
    fixture = ExvcrUtils.response_fixture("deleteZoneRecord/success.http", [url: @client.base_url <> "v2/1010/zones/example.weppos/records/2", method: :delete])
    use_cassette :stub, fixture do
      assert :ok == @service.delete(@client, 1010, "example.weppos", r, [])
    end
  end
end

