defmodule Dnsimple.RegistrarWhoisPrivacyService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.WhoisPrivacy

  @doc """
  Gets the whois privacy for the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#get
  """
  @spec whois_privacy(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, opts)
      |> Response.parse(WhoisPrivacy)
  end

  @doc """
  Enables the whois privacy for the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#enable
  """
  @spec enable_whois_privacy(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def enable_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")
    {headers, opts} = Client.headers(options)

    Client.put(client, url, _body = [], headers, opts)
      |> Response.parse(WhoisPrivacy)
  end

  @doc """
  Disables the whois privacy for the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#disable
  """
  @spec disable_whois_privacy(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def disable_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")
    {headers, opts} = Client.headers(options)

    Client.delete(client, url, headers, opts)
      |> Response.parse(WhoisPrivacy)
  end

end
