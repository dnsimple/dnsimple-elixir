defmodule Dnsimple.RegistrarWhoisPrivacyService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.WhoisPrivacy

  @doc """
  Gets the whois privacy for the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#get
  """
  @spec whois_privacy(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def whois_privacy(client, account_id, domain_name, headers \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.get(client, url, headers, options)
      |> Response.parse(WhoisPrivacy)
  end

end
