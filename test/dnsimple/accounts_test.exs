defmodule Dnsimple.AccountsTest do
  use TestCase, async: false

  @module Dnsimple.Accounts

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_accounts" do
    test "returns the accounts in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/accounts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listAccounts/success-account.http")
      end)

      {:ok, response} = @module.list_accounts(client)
      assert response.__struct__ == Dnsimple.Response
    end

    test "returns the account when using an account token", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/accounts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listAccounts/success-account.http")
      end)

      {:ok, response} = @module.list_accounts(client)

      data = response.data
      assert length(data) == 1
      assert Enum.all?(data, fn element -> element.__struct__ == Dnsimple.Account end)
      assert Enum.all?(data, fn element -> is_integer(element.id) end)
      assert Enum.all?(data, fn element -> is_binary(element.email) end)
      assert Enum.all?(data, fn element -> is_binary(element.name) end)
      assert Enum.all?(data, fn element -> is_binary(element.plan_identifier) end)
    end

    test "returns all user accounts when using a user token", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/accounts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listAccounts/success-user.http")
      end)

      {:ok, response} = @module.list_accounts(client)

      data = response.data
      assert length(data) == 2
      assert Enum.all?(data, fn element -> element.__struct__ == Dnsimple.Account end)
      assert Enum.all?(data, fn element -> is_integer(element.id) end)
      assert Enum.all?(data, fn element -> is_binary(element.email) end)
      assert Enum.all?(data, fn element -> is_binary(element.plan_identifier) end)
    end
  end
end
