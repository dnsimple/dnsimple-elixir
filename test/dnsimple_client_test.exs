defmodule DnsimpleClientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Client


  test "initialize with defaults" do
    client = %Dnsimple.Client{}
    assert client.access_token == nil
    assert client.base_url == "https://api.dnsimple.com"
  end


  test ".versioned joins path with current api version" do
    assert Dnsimple.Client.versioned("/whoami") == "/v2/whoami"
  end
end


defmodule DnsimpleHttpClientTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test ".execute sets a custom user agent" do
    client = %Dnsimple.Client{}

    use_cassette :stub, [method: :get] do
      {:ok, response} = Dnsimple.Client.execute(client, :get, "/")
    end
  end

end
