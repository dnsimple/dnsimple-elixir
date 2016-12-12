defmodule Dnsimple.IdentityTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Identity
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  describe ".whoami" do
    setup do
      {:ok, method: "get", url: "#{@client.base_url}/v2/whoami"}
    end

    test "returns the user in a DNSimple response", %{method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture("whoami/success-user.http", method: method, url: url) do
        {:ok, response} = @module.whoami(@client)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Whoami

        assert data.account == nil

        user = data.user
        assert user.__struct__ == Dnsimple.User
        assert user.id == 1
        assert user.email == "example-user@example.com"
      end
    end

    test "returns the account in a DNSimple response", %{method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture("whoami/success-account.http", method: method, url: url) do
        {:ok, response} = @module.whoami(@client)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Whoami

        assert data.user == nil

        account = data.account
        assert account.__struct__ == Dnsimple.Account
        assert account.id == 1
        assert account.email == "example-account@example.com"
        assert account.plan_identifier == nil
      end
    end
  end

end
