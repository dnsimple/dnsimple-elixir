defmodule Dnsimple.ZonesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Zones
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  describe ".list_zones" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/zones"
      {:ok, fixture: "listZones/success.http", method: "get", url: url}
    end

    test "returns the zones in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zones(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
        assert Enum.count(response.data) == 2
        assert Enum.all?(response.data, fn(item) -> item.__struct__ == Dnsimple.Zone end)
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/zones?sort=name%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zones(@client, @account_id, sort: "name:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/zones?name_like=example"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} =@module.list_zones(@client, @account_id, filter: [name_like: "example"])
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_zone" do
    test "returns the zone in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/zones/example.com"
      method  = "get"
      fixture = "getZone/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_zone(@client, @account_id, _zone_id = "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Zone
        assert data.id == 1
        assert data.account_id == @account_id
        assert data.name == "example-alpha.com"
        assert data.reverse == false
        assert data.created_at == "2015-04-23T07:40:03Z"
        assert data.updated_at == "2015-04-23T07:40:03Z"
      end
    end
  end


  @zone_id "example.com"


  describe ".get_zone_file" do
    test "returns the zone file in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/file"
      method  = "get"
      fixture = "getZoneFile/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_zone_file(@client, @account_id, @zone_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.zone == "$ORIGIN example.com.\n$TTL 1h\nexample.com. 3600 IN SOA ns1.dnsimple.com. admin.dnsimple.com. 1453132552 86400 7200 604800 300\nexample.com. 3600 IN NS ns1.dnsimple.com.\nexample.com. 3600 IN NS ns2.dnsimple.com.\nexample.com. 3600 IN NS ns3.dnsimple.com.\nexample.com. 3600 IN NS ns4.dnsimple.com.\n"
      end
    end
  end


  describe ".get_zone_distribution" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/distribution"
      {:ok, method: "get", url: url}
    end

    test "returns the zone's distribution status in a Dnsimple.Response", %{method: method, url: url} do
      fixture = "getZoneDistribution/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_zone_distribution(@client, @account_id, @zone_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneDistribution
        assert data.distributed == true
      end
    end

    test "returns an error if the distribution status couldn't be retrieved", %{method: method, url: url} do
      fixture = "getZoneDistribution/error.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:error, response} = @module.get_zone_distribution(@client, @account_id, @zone_id)
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 500: Could not query zone, connection timed out"
      end
    end
  end


  describe ".list_zone_records" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records"
      {:ok, fixture: "listZoneRecords/success.http", method: "get", url: url}
    end

    test "returns the zone's records in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zone_records(@client, @account_id, @zone_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert Enum.count(data) == 5
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.ZoneRecord end)
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records?sort=name%3Aasc%2Ctype%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zone_records(@client, @account_id, @zone_id, sort: "name:asc,type:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records?type=A"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zone_records(@client, @account_id, @zone_id, filter: [type: "A"])
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_zone_record" do
    test "returns the record in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records/5"
      method  = "get"
      fixture = "getZoneRecord/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_zone_record(@client, @account_id, @zone_id, _record_id = 5)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneRecord
        assert data.id == 5
        assert data.zone_id == "example.com"
        assert data.parent_id == nil
        assert data.type == "MX"
        assert data.name == ""
        assert data.content == "mxa.example.com"
        assert data.ttl == 600
        assert data.priority == 10
        assert data.system_record == false
        assert data.regions == ["SV1", "IAD"]
        assert data.created_at == "2016-10-05T09:51:35Z"
        assert data.updated_at == "2016-10-05T09:51:35Z"
      end
    end
  end


  describe ".create_zone_record" do
    test "creates the record and retuns it in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records"
      fixture = "createZoneRecord/created.http"
      method  = "post"
      attributes  = %{type: "A", name: "www", content: "127.0.0.1", ttl: 600}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_zone_record(@client, @account_id, @zone_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneRecord
        assert data.id == 1
        assert data.zone_id == "example.com"
        assert data.parent_id == nil
        assert data.type == "A"
        assert data.name == "www"
        assert data.content == "127.0.0.1"
        assert data.ttl == 600
        assert data.priority == nil
        assert data.system_record == false
        assert data.regions == ["global"]
        assert data.created_at == "2016-01-07T17:45:13Z"
        assert data.updated_at == "2016-01-07T17:45:13Z"
      end
    end
  end


  describe ".update_zone_record" do
    test "updates the record and returns it in a Dnsimple.Response" do
      url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records/5"
      method   = "patch"
      fixture   = "updateZoneRecord/success.http"
      attributes  = %{content: "mxb.example.com", ttl: 3600, priority: 20, regions: ["global"]}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.update_zone_record(@client, @account_id, @zone_id, record_id = 5, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneRecord
        assert data.id == record_id
        assert data.zone_id == "example.com"
        assert data.parent_id == nil
        assert data.type == "MX"
        assert data.name == ""
        assert data.content == "mxb.example.com"
        assert data.ttl == 3600
        assert data.priority == 20
        assert data.system_record == false
        assert data.regions == ["global"]
        assert data.created_at == "2016-10-05T09:51:35Z"
        assert data.updated_at == "2016-10-05T09:51:35Z"
      end
    end
  end


  describe ".delete_zone_record" do
    test "deletes the record and returns an empty Dnsimple.Response" do
      url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{@zone_id}/records/5"
      method    = "delete"
      fixture   = "deleteZoneRecord/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_zone_record(@client, @account_id, @zone_id, _record_id = 5)

        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


end
