defmodule Dnsimple.ZonesTest do
  use TestCase, async: false

  @module Dnsimple.Zones
  @account_id 1010
  @record_id 1
  @zone_id "example.com"

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_zones" do
    test "returns the zones in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/zones", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listZones/success.http")
      end)

      {:ok, response} = @module.list_zones(client, @account_id)
      assert response.__struct__ == Dnsimple.Response
      assert Enum.count(response.data) == 2
      assert Enum.all?(response.data, fn item -> item.__struct__ == Dnsimple.Zone end)
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/zones", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listZones/success.http")
      end)

      {:ok, response} = @module.list_zones(client, @account_id, sort: "name:desc")
      assert response.__struct__ == Dnsimple.Response
    end

    test "supports filtering", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/zones", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listZones/success.http")
      end)

      {:ok, response} = @module.list_zones(client, @account_id, filter: [name_like: "example"])
      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_zone" do
    test "returns the zone in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/zones/example.com", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getZone/success.http")
      end)

      {:ok, response} = @module.get_zone(client, @account_id, _zone_id = "example.com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Zone
      assert data.id == 1
      assert data.account_id == @account_id
      assert data.name == "example-alpha.com"
      assert data.reverse == false
      assert data.secondary == false
      assert data.last_transferred_at == nil
      assert data.active == true
      assert data.created_at == "2015-04-23T07:40:03Z"
      assert data.updated_at == "2015-04-23T07:40:03Z"
    end
  end

  describe ".get_zone_file" do
    test "returns the zone file in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/file",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "getZoneFile/success.http")
        end
      )

      {:ok, response} = @module.get_zone_file(client, @account_id, @zone_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data

      assert data.zone ==
               "$ORIGIN example.com.\n$TTL 1h\nexample.com. 3600 IN SOA ns1.dnsimple.com. admin.dnsimple.com. 1453132552 86400 7200 604800 300\nexample.com. 3600 IN NS ns1.dnsimple.com.\nexample.com. 3600 IN NS ns2.dnsimple.com.\nexample.com. 3600 IN NS ns3.dnsimple.com.\nexample.com. 3600 IN NS ns4.dnsimple.com.\n"
    end
  end

  describe ".check_zone_distribution" do
    test "returns the zone's distribution status in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/distribution",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "checkZoneDistribution/success.http")
        end
      )

      {:ok, response} = @module.check_zone_distribution(client, @account_id, @zone_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.ZoneDistribution
      assert data.distributed == true
    end

    test "returns the zone's distribution failing status in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/distribution",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "checkZoneDistribution/failure.http")
        end
      )

      {:ok, response} = @module.check_zone_distribution(client, @account_id, @zone_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.ZoneDistribution
      assert data.distributed == false
    end

    test "returns an error if the zone distribution status couldn't be retrieved", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/distribution",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "checkZoneDistribution/error.http")
        end
      )

      {:error, response} = @module.check_zone_distribution(client, @account_id, @zone_id)
      assert response.__struct__ == Dnsimple.RequestError
      assert response.message == "HTTP 504: Could not query zone, connection timed out"
    end
  end

  describe ".check_zone_record_distribution" do
    test "returns the zone record's distribution status in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "checkZoneRecordDistribution/success.http")
        end
      )

      {:ok, response} =
        @module.check_zone_record_distribution(client, @account_id, @zone_id, @record_id)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.ZoneDistribution
      assert data.distributed == true
    end

    test "returns the zone record's distribution failing status in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "checkZoneRecordDistribution/failure.http")
        end
      )

      {:ok, response} =
        @module.check_zone_record_distribution(client, @account_id, @zone_id, @record_id)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.ZoneDistribution
      assert data.distributed == false
    end

    test "returns an error if the zone record distribution status couldn't be retrieved", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records/#{@record_id}/distribution",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "checkZoneRecordDistribution/error.http")
        end
      )

      {:error, response} =
        @module.check_zone_record_distribution(client, @account_id, @zone_id, @record_id)

      assert response.__struct__ == Dnsimple.RequestError
      assert response.message == "HTTP 504: Could not query zone, connection timed out"
    end
  end

  describe ".list_zone_records" do
    test "returns the zone's records in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listZoneRecords/success.http")
        end
      )

      {:ok, response} = @module.list_zone_records(client, @account_id, @zone_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert Enum.count(data) == 5
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.ZoneRecord end)
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listZoneRecords/success.http")
        end
      )

      {:ok, response} =
        @module.list_zone_records(client, @account_id, @zone_id, sort: "name:asc,type:desc")

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports filtering", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listZoneRecords/success.http")
        end
      )

      {:ok, response} =
        @module.list_zone_records(client, @account_id, @zone_id, filter: [type: "A"])

      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_zone_record" do
    test "returns the record in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/zones/#{@zone_id}/records/5",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "getZoneRecord/success.http")
        end
      )

      {:ok, response} = @module.get_zone_record(client, @account_id, @zone_id, _record_id = 5)
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

  describe ".create_zone_record" do
    test "creates the record and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{type: "A", name: "www", content: "127.0.0.1", ttl: 600}

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/zones/#{@zone_id}/records",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == Poison.encode!(attributes)
          ExvcrUtils.respond_with_fixture(conn, "createZoneRecord/created.http")
        end
      )

      {:ok, response} = @module.create_zone_record(client, @account_id, @zone_id, attributes)
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

  describe ".update_zone_record" do
    test "updates the record and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{content: "mxb.example.com", ttl: 3600, priority: 20, regions: ["global"]}

      Bypass.expect_once(
        bypass,
        "PATCH",
        "/v2/#{@account_id}/zones/#{@zone_id}/records/5",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == Poison.encode!(attributes)
          ExvcrUtils.respond_with_fixture(conn, "updateZoneRecord/success.http")
        end
      )

      {:ok, response} =
        @module.update_zone_record(client, @account_id, @zone_id, record_id = 5, attributes)

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

  describe ".delete_zone_record" do
    test "deletes the record and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/zones/#{@zone_id}/records/5",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "deleteZoneRecord/success.http")
        end
      )

      {:ok, response} =
        @module.delete_zone_record(client, @account_id, @zone_id, _record_id = 5)

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".activate_dns" do
    test "activates DNS for the zone and returns the zone in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "PUT",
        "/v2/#{@account_id}/zones/#{@zone_id}/activation",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "activateZoneService/success.http")
        end
      )

      {:ok, response} = @module.activate_dns(client, @account_id, @zone_id)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Zone
      assert response.data.id == 1
      assert response.data.account_id == @account_id
      assert response.data.name == "example.com"
      assert response.data.reverse == false
      assert response.data.created_at == "2022-09-28T04:45:24Z"
      assert response.data.updated_at == "2023-07-06T11:19:48Z"
    end
  end

  describe ".deactivate_dns" do
    test "deactivates DNS for the zone and returns the zone in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/zones/#{@zone_id}/activation",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "deactivateZoneService/success.http")
        end
      )

      {:ok, response} = @module.deactivate_dns(client, @account_id, @zone_id)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Zone
      assert response.data.id == 1
      assert response.data.account_id == @account_id
      assert response.data.name == "example.com"
      assert response.data.reverse == false
      assert response.data.created_at == "2022-09-28T04:45:24Z"
      assert response.data.updated_at == "2023-08-08T04:19:52Z"
    end
  end
end
