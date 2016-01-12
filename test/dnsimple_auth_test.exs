defmodule DnsimpleAuthTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Auth

  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test/"}


  test "whoami" do
    [body, status_code] = [~s({"data":{"user":null,"account":{"id":24,"email":"example-account@example.com"}}}), 200]
    use_cassette :stub, [url: "https://api.dnsimple.test/v2/whoami", body: body, status_code: status_code] do
      response = Dnsimple.Auth.whoami(@client)
      assert is_map(response)
      assert %{"account" => _, "user" => _} = response
    end
  end

end

