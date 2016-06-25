defmodule DnsimpleZonesServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.ZonesService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010
  @zone_id "example.com"

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

  test ".list_zones supports sorting" do
    fixture = ExvcrUtils.response_fixture("listZones/success.http", [method: "get", url: @client.base_url <> "/v2/#{@account_id}/zones?sort=name%3Adesc"])
    use_cassette :stub, fixture do
      @service.list_zones(@client, @account_id, [sort: "name:desc"])
    end
  end

  test ".list_zones supports filtering" do
    fixture = ExvcrUtils.response_fixture("listZones/success.http", [method: "get", url: @client.base_url <> "/v2/#{@account_id}/zones?name_like=example"])
    use_cassette :stub, fixture do
      @service.list_zones(@client, @account_id, [filter: [name_like: "example"]])
    end
  end

  test ".zone" do
    fixture = "getZone/success.http"
    method  = "get"
    url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.zone(@client, @account_id, @zone_id)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Zone
      assert response.data == %Dnsimple.Zone{
        id: 1,
        account_id: @account_id,
        name: "example-alpha.com",
        reverse: false,
        created_at: "2015-04-23T07:40:03.045Z",
        updated_at: "2015-04-23T07:40:03.051Z"
      }
    end
  end

  test ".list_records" do
    fixture = "listZoneRecords/success.http"
    method  = "get"
    url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.list_records(@client, @account_id, @zone_id)

      assert response.__struct__ == Dnsimple.Response
      assert Enum.count(response.data) == 5
      assert Enum.all?(response.data, fn(item) -> item.__struct__ == Dnsimple.ZoneRecord end)
    end
  end

  test ".list_records supports sorting" do
    fixture = ExvcrUtils.response_fixture("listZoneRecords/success.http", [method: "get", url: @client.base_url <> "/v2/#{@account_id}/zones/#{@zone_id}/records?sort=name%3Aasc%2Ctype%3Adesc"])
    use_cassette :stub, fixture do
      @service.list_records(@client, @account_id, @zone_id, [sort: "name:asc,type:desc"])
    end
  end

  test ".list_records supports filtering" do
    fixture = ExvcrUtils.response_fixture("listZoneRecords/success.http", [method: "get", url: @client.base_url <> "/v2/#{@account_id}/zones/#{@zone_id}/records?name_like=example&type=A"])
    use_cassette :stub, fixture do
      @service.list_records(@client, @account_id, @zone_id, [filter: [name_like: "example", type: "A"]])
    end
  end

  test ".create_record" do
    fixture = "createZoneRecord/created.http"
    method  = "post"
    url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records"
    attributes  = %{type: "A", name: "www", content: "127.0.0.1", ttl: 600}
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.create_record(@client, @account_id, @zone_id, attributes)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.ZoneRecord
      assert response.data == %Dnsimple.ZoneRecord{
        id: 64784,
        zone_id: @zone_id,
        parent_id: nil,
        type: "A",
        name: "www",
        content: "127.0.0.1",
        ttl: 600,
        priority: nil,
        system_record: false,
        created_at: "2016-01-07T17:45:13.653Z",
        updated_at: "2016-01-07T17:45:13.653Z"
      }
    end
  end

  test ".record" do
    fixture   = "getZoneRecord/success.http"
    method    = "get"
    record_id = 64784
    url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records/#{record_id}"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.record(@client, @account_id, @zone_id, record_id)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.ZoneRecord
      assert response.data == %Dnsimple.ZoneRecord{
        id: 64784,
        zone_id: @zone_id,
        parent_id: nil,
        type: "A",
        name: "www",
        content: "127.0.0.1",
        ttl: 600,
        priority: nil,
        system_record: false,
        created_at: "2016-01-07T17:45:13.653Z",
        updated_at: "2016-01-07T17:45:13.653Z"
      }
    end
  end

  test ".update_record" do
    fixture   = "updateZoneRecord/success.http"
    method   = "patch"
    record_id = 64784
    url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records/#{record_id}"
    attributes  = %{ttl: 3600}
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.update_record(@client, @account_id, @zone_id, record_id, attributes)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.ZoneRecord
      assert response.data == %Dnsimple.ZoneRecord{
        id: 64784,
        zone_id: @zone_id,
        parent_id: nil,
        type: "A",
        name: "www",
        content: "127.0.0.1",
        ttl: 3600,
        priority: nil,
        system_record: false,
        created_at: "2016-01-07T17:45:13.653Z",
        updated_at: "2016-01-07T17:54:46.722Z"
      }
    end
  end

  test ".delete_record" do
    fixture   = "deleteZoneRecord/success.http"
    method    = "delete"
    record_id = 64784
    url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records/#{record_id}"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.delete_record(@client, @account_id, @zone_id, record_id)

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

end
