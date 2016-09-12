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

    test "can be called using the alias .zones", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.zones(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_zone" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/example.com"
      {:ok, fixture: "getZone/success.http", method: "get", url: url}
    end

    test "returns the zone in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_zone(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Zone
        assert data.id == 1
        assert data.account_id == @account_id
        assert data.name == "example-alpha.com"
        assert data.reverse == false
        assert data.created_at == "2015-04-23T07:40:03.045Z"
        assert data.updated_at == "2015-04-23T07:40:03.051Z"
      end
    end

    test "can be called using the alias .zone", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.zone(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".list_zone_records" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/example.com/records"
      {:ok, fixture: "listZoneRecords/success.http", method: "get", url: url}
    end

    test "returns the zone's records in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zone_records(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert Enum.count(data) == 5
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.ZoneRecord end)
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/example.com/records?sort=name%3Aasc%2Ctype%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zone_records(@client, @account_id, "example.com", sort: "name:asc,type:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/example.com/records?type=A"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_zone_records(@client, @account_id, "example.com", filter: [type: "A"])
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .zone_records", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.zone_records(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_zone_record" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/zones/#{"example.com"}/records/64784"
      {:ok, fixture: "getZoneRecord/success.http", method: "get", url: url}
    end

    test "returns the record in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_zone_record(@client, @account_id, "example.com", _record_id = 64784)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneRecord
        assert data.id == 64784
        assert data.zone_id == "example.com"
        assert data.parent_id == nil
        assert data.type == "A"
        assert data.name == "www"
        assert data.content == "127.0.0.1"
        assert data.ttl == 600
        assert data.priority == nil
        assert data.system_record == false
        assert data.created_at == "2016-01-07T17:45:13.653Z"
        assert data.updated_at == "2016-01-07T17:45:13.653Z"
      end
    end

    test "can be called using the alias .zone_record", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.zone_record(@client, @account_id, "example.com", _record_id = 64784)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_zone_record" do
    test "creates the record and retuns it in a Dnsiple.Response" do
      fixture = "createZoneRecord/created.http"
      method  = "post"
      url     = "#{@client.base_url}/v2/#{@account_id}/zones/#{"example.com"}/records"
      attributes  = %{type: "A", name: "www", content: "127.0.0.1", ttl: 600}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_zone_record(@client, @account_id, "example.com", attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneRecord
        assert data.id == 64784
        assert data.zone_id == "example.com"
        assert data.parent_id == nil
        assert data.type == "A"
        assert data.name == "www"
        assert data.content == "127.0.0.1"
        assert data.ttl == 600
        assert data.priority == nil
        assert data.system_record == false
        assert data.created_at == "2016-01-07T17:45:13.653Z"
        assert data.updated_at == "2016-01-07T17:45:13.653Z"
      end
    end
  end


  describe ".update_zone_record" do
    test "updates the record and returns it in a Dnsimple.Response" do
      fixture   = "updateZoneRecord/success.http"
      method   = "patch"
      record_id = 64784
      url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{"example.com"}/records/#{record_id}"
      attributes  = %{ttl: 3600}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.update_zone_record(@client, @account_id, "example.com", record_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.ZoneRecord
        assert data.id == 64784
        assert data.zone_id == "example.com"
        assert data.parent_id == nil
        assert data.type == "A"
        assert data.name == "www"
        assert data.content == "127.0.0.1"
        assert data.ttl == 3600
        assert data.priority == nil
        assert data.system_record == false
        assert data.created_at == "2016-01-07T17:45:13.653Z"
        assert data.updated_at == "2016-01-07T17:54:46.722Z"
      end
    end
  end

  describe ".delete_zone_record" do
    test "deletes the record and returns an empty Dnsimple.Response" do
      fixture   = "deleteZoneRecord/success.http"
      method    = "delete"
      record_id = 64784
      url       = "#{@client.base_url}/v2/#{@account_id}/zones/#{"example.com"}/records/#{record_id}"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_zone_record(@client, @account_id, "example.com", record_id)

        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end

end
