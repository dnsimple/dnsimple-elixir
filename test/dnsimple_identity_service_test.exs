defmodule DnsimpleIdentityServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.IdentityService

  @service Dnsimple.IdentityService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".whoami" do
    use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", [url: "~r/\/v2\/whoami/$"]) do
      response = @service.whoami(@client)
      assert is_map(response)
      assert %{"account" => _, "user" => _} = response
    end
  end

end

