defmodule Dnsimple.OauthService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.OauthToken

  def authorize_url(client, client_id, options \\ []) do
    host  = String.replace(client.base_url, "https://api.", "")
    query = Keyword.merge([response_type: "code", client_id: client_id], options)

    URI.to_string(%URI{scheme: "https", host: host, path: "/oauth/authorize", query: URI.encode_query(query)})
  end

  def exchange_authorization_for_token(client, attributes, headers \\ [], options \\ []) do
    url        = Client.versioned("/oauth/access_token")

    Client.post(client, url, attributes, headers, options)
      |> Response.parse(OauthToken)
  end

end
