defmodule Dnsimple.OauthTest do
  use TestCase, async: false

  @module Dnsimple.Oauth

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  test "generating the authorize URL with client_id" do
    url_client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "https://api.dnsimple.test"
    }

    client_id = "a1b2c3d4"

    assert @module.authorize_url(url_client, client_id) ==
             "https://dnsimple.test/oauth/authorize?response_type=code&client_id=a1b2c3d4"
  end

  test "generating the authorize URL with client_id and extra options" do
    url_client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "https://api.dnsimple.test"
    }

    client_id = "a1b2c3d4"
    state = "12345678"

    assert @module.authorize_url(url_client, client_id, state: state, foo: "bar") ==
             "https://dnsimple.test/oauth/authorize?response_type=code&client_id=a1b2c3d4&state=12345678&foo=bar"
  end

  test "exchanging the authorization token", %{bypass: bypass, client: client} do
    attributes = %{
      code: "w0x1y2z3",
      client_id: "a1b2c3d4",
      client_secret: "x0x1x2x3x4x5",
      state: "12345678",
      redirect_uri: "https://redirect.to/url",
      grant_type: "authorization_code"
    }

    Bypass.expect_once(bypass, "POST", "/v2/oauth/access_token", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert body == JSON.encode!(attributes)
      ExvcrUtils.respond_with_fixture(conn, "oauthAccessToken/success.http")
    end)

    {:ok, response} = @module.exchange_authorization_for_token(client, attributes)

    assert response.__struct__ == Dnsimple.Response
    token = response.data
    assert token.__struct__ == Dnsimple.OauthToken
    assert token.access_token == "zKQ7OLqF5N1gylcJweA9WodA000BUNJD"
    assert token.token_type == "Bearer"
    assert token.scope == nil
    assert token.account_id == 1
  end
end
