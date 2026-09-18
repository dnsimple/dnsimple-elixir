defmodule Dnsimple.DnsAnalyticsTest do
  use TestCase, async: false

  @module Dnsimple.DnsAnalytics
  @account_id 1010

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".query" do
    test "returns the rows in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      {:ok, response} = @module.query(client, @account_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 12
      assert Enum.all?(data, fn row -> row.__struct__ == Dnsimple.DnsAnalyticsRow end)

      row = List.first(data)
      assert row.zone_name == "bar.com"
      assert row.date == "2023-12-08"
      assert row.volume == 1200

      row = List.last(data)
      assert row.zone_name == "foo.com"
      assert row.date == "2024-01-08"
      assert row.volume == 1200
    end

    test "returns the pagination", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      {:ok, response} = @module.query(client, @account_id)

      pagination = response.pagination
      assert pagination.__struct__ == Dnsimple.Response.Pagination
      assert pagination.current_page == 0
      assert pagination.per_page == 100
      assert pagination.total_entries == 93
      assert pagination.total_pages == 1
    end

    test "returns the query", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      {:ok, response} = @module.query(client, @account_id)

      query = response.query
      assert query["account_id"] == 1
      assert query["start_date"] == "2023-12-08"
      assert query["end_date"] == "2024-01-08"
      assert query["sort"] == "zone_name:asc,date:asc"
      assert query["page"] == 0
      assert query["per_page"] == 100
      assert query["groupings"] == "zone_name,date"
    end

    test "supports filtering", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"start_date" => "2023-12-08", "end_date" => "2024-01-08"}
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      @module.query(client, @account_id,
        filter: [start_date: "2023-12-08", end_date: "2024-01-08"]
      )
    end

    test "supports groupings", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"groupings" => "zone_name,date"}
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      @module.query(client, @account_id, groupings: "zone_name,date")
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"sort" => "volume:desc,zone_name:asc"}
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      @module.query(client, @account_id, sort: "volume:desc,zone_name:asc")
    end

    test "supports pagination", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/dns_analytics", fn conn ->
        conn = Plug.Conn.fetch_query_params(conn)
        assert conn.query_params == %{"page" => "2", "per_page" => "10"}
        FixtureUtils.respond_with_fixture(conn, "dnsAnalytics/success.http")
      end)

      @module.query(client, @account_id, page: 2, per_page: 10)
    end
  end
end
