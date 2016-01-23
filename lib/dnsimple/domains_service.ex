defmodule Dnsimple.DomainsService do
  alias Dnsimple.Client
  alias Dnsimple.Domain

  @spec domains(Client.t, String.t | integer, Keyword.t) :: [Domain.t]
  def domains(client, account_id, options \\ []) do
    response = Client.get(client, Client.versioned("#{account_id}/domains"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> Dnsimple.Utils.collection_to_struct(Domain)
  end

  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Domain.t
  def domain(client, account_id \\ Dnsimple.Client.__WILDCARD_ACCOUNT, domain_id, options \\ []) do
    response = Client.get(client, Client.versioned("#{account_id}/domains/#{domain_id}"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> Dnsimple.Utils.single_to_struct(Domain)
  end

end

