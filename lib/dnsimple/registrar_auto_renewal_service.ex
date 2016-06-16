defmodule Dnsimple.RegistrarAutoRenewalService do
  alias Dnsimple.Client
  alias Dnsimple.Response

  @doc """
  Enable auto-renewal for the domain.

  See: https://developer.dnsimple.com/v2/registrar/auto-renewal/#enable
  """
  @spec enable_auto_renewal(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def enable_auto_renewal(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")
    {headers, opts} = Client.headers(options)

    Client.put(client, url, headers, opts)
      |> Response.parse(nil)
  end

  @doc """
  Disable auto-renewal for the domain.

  See: https://developer.dnsimple.com/v2/registrar/auto-renewal/#disable
  """
  @spec disable_auto_renewal(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def disable_auto_renewal(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")
    {headers, opts} = Client.headers(options)

    Client.delete(client, url, headers, opts)
      |> Response.parse(nil)
  end

end
