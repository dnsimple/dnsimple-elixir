defmodule Dnsimple.OauthService do

  def authorize_url(client, client_id, options \\ []) do
    host  = String.replace(client.base_url, "https://api.", "")
    query = Keyword.merge([response_type: "code", client_id: client_id], options)

    URI.to_string(%URI{scheme: "https", host: host, path: "/oauth/authorize", query: URI.encode_query(query)})
  end

end
