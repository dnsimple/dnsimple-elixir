defmodule DnsimpleClientTest do
  use ExUnit.Case, async: true
  doctest Dnsimple.Client


  test "initialize with defaults" do
    client = %Dnsimple.Client{}
    assert client.access_token == nil
    assert client.base_url == "https://api.dnsimple.com"
  end


  test "versioned joins path with current api version" do
    assert Dnsimple.Client.versioned("/whoami") == "/v2/whoami"
  end

end

