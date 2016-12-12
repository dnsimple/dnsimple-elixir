defmodule Dnsimple.AccountsTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Accounts
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  describe ".list_accounts" do
    setup do
      {:ok, method: "get", url: "#{@client.base_url}/v2/accounts"}
    end

    test "returns the accounts in a Dnsimple.Response", %{method: method, url: url} do
      fixture = "listAccounts/success-account.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_accounts(@client)
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "returns the account when using an account token", %{method: method, url: url} do
      fixture = "listAccounts/success-account.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_accounts(@client)

        data = response.data
        assert length(data) == 1
        assert Enum.all?(data, fn(element) -> element.__struct__ == Dnsimple.Account end)
        assert Enum.all?(data, fn(element) -> is_integer(element.id) end)
        assert Enum.all?(data, fn(element) -> is_binary(element.email) end)
        assert Enum.all?(data, fn(element) -> is_binary(element.plan_identifier) end)
      end
    end

    test "returns all user accounts when using a user token", %{method: method, url: url} do
      fixture = "listAccounts/success-user.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_accounts(@client)

        data = response.data
        assert length(data) == 2
        assert Enum.all?(data, fn(element) -> element.__struct__ == Dnsimple.Account end)
        assert Enum.all?(data, fn(element) -> is_integer(element.id) end)
        assert Enum.all?(data, fn(element) -> is_binary(element.email) end)
        assert Enum.all?(data, fn(element) -> is_binary(element.plan_identifier) end)
      end
    end
  end

end
