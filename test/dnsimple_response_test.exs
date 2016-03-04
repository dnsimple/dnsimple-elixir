defmodule DnsimpleResponseTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Client


  test ".new" do
    client = %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}
    use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", [method: "GET"]) do
      http     = Dnsimple.Client.execute(client, "GET", "/path")
      response = Dnsimple.Response.new(http, nil)

      assert response.http_response == http
      assert response.data == nil
    end
  end

  test ".new parses the rate-limit" do
    client = %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}
    use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", [method: "GET"]) do
      http     = Dnsimple.Client.execute(client, "GET", "/path")
      response = Dnsimple.Response.new(http, nil)

      assert response.rate_limit == 4000
      assert response.rate_limit_remaining == 3991
      assert response.rate_limit_reset == 1450451976
    end
  end

end
