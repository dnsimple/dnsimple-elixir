defmodule Dnsimple.BillingTest do
  require Decimal
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Billing
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  describe ".list_charges" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/billing/charges"
      {:ok, fixture: "listCharges/success.http", method: "get", url: url}
    end

    test "returns the charges in a Dnsimple.Response", %{method: method, url: url} do
      fixture = "listCharges/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_charges(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 3
        assert Enum.all?(data, fn(charge) -> charge.__struct__ == Dnsimple.Charge end)

        charge = List.first(data)
        assert charge.total_amount == Decimal.new("14.50")
        assert is_list(charge.items)

        charge_item = List.first(charge.items)
        assert charge_item.__struct__ == Dnsimple.Charge.ChargeItem
        assert charge_item.amount == Decimal.new("14.50")
        assert charge_item.product_type == "domain-registration"
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        @module.list_charges(@client, @account_id, headers: %{"X-Header" => "X-Value"})
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/billing/charges?start_date=2023-01-01"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        @module.list_charges(@client, @account_id, filter: [start_date: "2023-01-01"])
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/billing/charges?sort=invoiced%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        @module.list_charges(@client, @account_id, sort: "invoiced:desc")
      end
    end

    test "returns an error if the provided filter is bad", %{method: method, url: url} do
      fixture = "listCharges/fail-400-bad-filter.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:error, response} = @module.list_charges(@client, @account_id)
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 400: Invalid date format must be ISO8601 (YYYY-MM-DD)"
      end
    end
  end

end
