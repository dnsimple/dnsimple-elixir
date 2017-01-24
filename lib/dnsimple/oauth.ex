defmodule Dnsimple.Oauth do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.OauthToken

  @doc """
  Returns the URL to start the OAuth dance.

  See:
  - https://developer.dnsimple.com/v2/oauth/#step-1---authorization

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      Dnsimple.Oauth.authorize_url(client, client_id = "1z2y3x", state: "12345678")

  """
  @spec authorize_url(Client.t, String.t, Keyword.t) :: String.t
  def authorize_url(client, client_id, query \\ []) do
    host  = String.replace(client.base_url, "https://api.", "")
    query = Keyword.merge([response_type: "code", client_id: client_id], query)

    URI.to_string(%URI{scheme: "https", host: host, path: "/oauth/authorize", query: URI.encode_query(query)})
  end


  @doc """
  Returns the access token for a given authorization code.

  See:
  - https://developer.dnsimple.com/v2/oauth/#step-2---access-token

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      Dnsimple.Oauth.exchange_authorization_for_token(client, %{
        code: "authorization_code",
        state: "12345678",
        client_id: "1z2y3x",
        client_secret: "xXxXxX",
      })

  """
  @spec exchange_authorization_for_token(Client.t, Map.t, Keyword.t) :: String.t
  def exchange_authorization_for_token(client, attributes, options \\ []) do
    url        = Client.versioned("/oauth/access_token")
    attributes = Map.merge(attributes, %{grant_type: "authorization_code"})

    Client.post(client, url, attributes, options)
    |> Response.parse(%OauthToken{})
  end

end
