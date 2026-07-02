defmodule Dnsimple.IdentityTest do
  use TestCase, async: false

  @module Dnsimple.Identity

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".whoami" do
    test "returns the user in a DNSimple response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/whoami", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "whoami/success-user.http")
      end)

      {:ok, response} = @module.whoami(client)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Whoami

      assert data.account == nil

      user = data.user
      assert user.__struct__ == Dnsimple.User
      assert user.id == 1
      assert user.email == "example-user@example.com"
    end

    test "returns the account in a DNSimple response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/whoami", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "whoami/success-account.http")
      end)

      {:ok, response} = @module.whoami(client)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Whoami

      assert data.user == nil

      account = data.account
      assert account.__struct__ == Dnsimple.Account
      assert account.id == 1
      assert account.email == "example-account@example.com"
      assert account.plan_identifier == "teams-v1-monthly"
    end
  end
end
