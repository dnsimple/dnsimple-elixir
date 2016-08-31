defmodule Dnsimple.Oauth do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.OauthToken

  @doc """
  Returns the URL to start the OAuth dance.

  See: https://developer.dnsimple.com/v2/oauth/#step-1---authorization
  """
  @spec authorize_url(Client.t, String.t, Keyword.t) :: String.t
  def authorize_url(client, client_id, query \\ []) do
    host  = String.replace(client.base_url, "https://api.", "")
    query = Keyword.merge([response_type: "code", client_id: client_id], query)

    URI.to_string(%URI{scheme: "https", host: host, path: "/oauth/authorize", query: URI.encode_query(query)})
  end

  @doc """
  Obtains the access token.

  See: https://developer.dnsimple.com/v2/oauth/#step-2---access-token
  """
  @spec exchange_authorization_for_token(Client.t, Map.t, Keyword.t) :: String.t
  def exchange_authorization_for_token(client, attributes, options \\ []) do
    url        = Client.versioned("/oauth/access_token")
    attributes = Map.merge(attributes, %{grant_type: "authorization_code"})

    Client.post(client, url, attributes, options)
    |> Response.parse(OauthToken)
  end

end
