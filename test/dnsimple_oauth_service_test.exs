defmodule DnsimpleOauthTest do
  use ExUnit.Case, async: true
  alias Dnsimple.OauthService

  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test "generating the authorize URL with client_id" do
    client_id = "a1b2c3d4"

    assert OauthService.authorize_url(@client, client_id) ==
      "https://dnsimple.test/oauth/authorize?response_type=code&client_id=a1b2c3d4"
  end

  test "generating the authorize URL with client_id and extra optiosn" do
    client_id = "a1b2c3d4"
    state     = "12345678"

    assert OauthService.authorize_url(@client, client_id, state: state, foo: "bar") ==
      "https://dnsimple.test/oauth/authorize?response_type=code&client_id=a1b2c3d4&state=12345678&foo=bar"
  end

end
