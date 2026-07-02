defmodule Dnsimple.VanityNameServersTest do
  use TestCase, async: false

  @module Dnsimple.VanityNameServers
  @account_id 1010
  @domain_id "example.com"

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".enable_vanity_name_servers" do
    test "enables vanity name servers and returns them in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "PUT", "/v2/#{@account_id}/vanity/#{@domain_id}", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "enableVanityNameServers/success.http")
      end)

      {:ok, response} = @module.enable_vanity_name_servers(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert length(data) == 4
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.VanityNameServer end)
    end
  end

  describe ".disable_vanity_name_servers" do
    test "enables vanity name servers and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "DELETE", "/v2/#{@account_id}/vanity/#{@domain_id}", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "disableVanityNameServers/success.http")
      end)

      {:ok, response} = @module.disable_vanity_name_servers(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end
end
