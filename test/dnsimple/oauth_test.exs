defmodule Dnsimple.OauthTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.Oauth
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test "generating the authorize URL with client_id" do
    client_id = "a1b2c3d4"

    assert @service.authorize_url(@client, client_id) ==
      "https://dnsimple.test/oauth/authorize?response_type=code&client_id=a1b2c3d4"
  end

  test "generating the authorize URL with client_id and extra options" do
    client_id = "a1b2c3d4"
    state     = "12345678"

    assert @service.authorize_url(@client, client_id, state: state, foo: "bar") ==
      "https://dnsimple.test/oauth/authorize?response_type=code&client_id=a1b2c3d4&state=12345678&foo=bar"
  end

  test "exchanging the autorization token" do
    fixture     = "oauthAccessToken/success.http"
    method      = "post"
    url         = "#{@client.base_url}/v2/oauth/access_token"
    attributes  = %{
      code: "w0x1y2z3",
      client_id: "a1b2c3d4",
      client_secret: "x0x1x2x3x4x5",
      state: "12345678",
      redirect_uri: "https://redirect.to/url",
      grant_type: "authorization_code"
    }
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.exchange_authorization_for_token(@client, attributes)

      assert response.__struct__ == Dnsimple.Response
      token = response.data
      assert token.__struct__ == Dnsimple.OauthToken
      assert token.access_token == "zKQ7OLqF5N1gylcJweA9WodA000BUNJD"
      assert token.token_type  == "Bearer"
      assert token.scope  == nil
      assert token.account_id  == 1
    end
  end

end
