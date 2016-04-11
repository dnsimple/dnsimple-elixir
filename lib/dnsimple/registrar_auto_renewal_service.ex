defmodule Dnsimple.RegistrarAutoRenewalService do
  alias Dnsimple.Client
  alias Dnsimple.Response

  @doc """
  Enable auto-renewal for the domain.

  See: https://developer.dnsimple.com/v2/registrar/auto-renewal/#enable
  """
  @spec enable_auto_renewal(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def enable_auto_renewal(client, account_id, domain_name, headers \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")

    Client.put(client, url, headers, options)
      |> Response.parse(nil)
  end

end
