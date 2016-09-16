defmodule Dnsimple.VanityNameServersTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.VanityNameServers
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010
  @domain_id "example.com"

  describe ".enable_vanity_name_servers" do
    test "enables vanity name servers and returns them in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/vanity/#{@domain_id}"
      method  = "put"
      fixture = "enableVanityNameServers/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.enable_vanity_name_servers(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert length(data) == 4
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.VanityNameServer end)
      end
    end
  end

end
