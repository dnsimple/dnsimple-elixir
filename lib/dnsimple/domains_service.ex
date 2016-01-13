defmodule Dnsimple.DomainsService do
  alias Dnsimple.Client
  alias Dnsimple.Domain

  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Domain.t
  def domain(client, account_id \\ Dnsimple.Client.__WILDCARD_ACCOUNT, domain_id, options \\ []) do
    response = Client.get(client, Client.versioned("#{account_id}/domains/#{domain_id}"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> Dnsimple.Utils.map_to_struct(Domain)
  end

end

