defmodule Dnsimple.OauthService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.OauthToken

  def authorize_url(client, client_id, options \\ []) do
    host  = String.replace(client.base_url, "https://api.", "")
    query = Keyword.merge([response_type: "code", client_id: client_id], options)

    URI.to_string(%URI{scheme: "https", host: host, path: "/oauth/authorize", query: URI.encode_query(query)})
  end

  def exchange_authorization_for_token(client, code, client_id, client_secret, options \\ []) do
    url        = Client.versioned("/oauth/access_token")
    attributes = Keyword.take(options, [:state, :redirect_uri])
                   |> Keyword.merge(code: code, client_id: client_id, client_secret: client_secret)
                   |> Enum.into(%{})
    headers    = []
    options    = Keyword.delete(options, :state)
                   |> Keyword.delete(:redirect_uri)

    Client.post(client, url, attributes, headers, options)
      |> Response.parse(OauthToken)
  end

end
