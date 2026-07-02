defmodule Dnsimple.BillingTest do
  require Decimal
  use TestCase, async: false

  @module Dnsimple.Billing
  @account_id 1010

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_charges" do
    test "returns the charges in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/billing/charges", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listCharges/success.http")
      end)

      {:ok, response} = @module.list_charges(client, @account_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 4
      assert Enum.all?(data, fn charge -> charge.__struct__ == Dnsimple.Charge end)

      charge = List.first(data)
      assert charge.total_amount == Decimal.new("14.50")
      assert is_list(charge.items)

      charge_item = List.first(charge.items)
      assert charge_item.__struct__ == Dnsimple.Charge.ChargeItem
      assert charge_item.amount == Decimal.new("14.50")
      assert charge_item.product_type == "domain-registration"

      cert_charge = List.last(data)
      assert cert_charge.reference == "5-2"
      cert_item = List.first(cert_charge.items)
      assert cert_item.product_type == "certificate-purchase"
      assert cert_item.product_reference == "42"
      assert is_binary(cert_item.product_reference)
    end

    test "sends custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/billing/charges", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listCharges/success.http")
      end)

      @module.list_charges(client, @account_id, headers: %{"X-Header" => "X-Value"})
    end

    test "supports filtering", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/billing/charges", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listCharges/success.http")
      end)

      @module.list_charges(client, @account_id, filter: [start_date: "2023-01-01"])
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/billing/charges", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listCharges/success.http")
      end)

      @module.list_charges(client, @account_id, sort: "invoiced:desc")
    end

    test "returns an error if the provided filter is bad", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/billing/charges", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listCharges/fail-400-bad-filter.http")
      end)

      {:error, response} = @module.list_charges(client, @account_id)
      assert response.__struct__ == Dnsimple.RequestError
      assert response.message == "HTTP 400: Invalid date format must be ISO8601 (YYYY-MM-DD)"
    end
  end
end
