defmodule Dnsimple.DomainsService do
  alias Dnsimple.Client
  alias Dnsimple.Domain

  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Domain.t
  def domain(client, account_id \\ Dnsimple.Client.__WILDCARD_ACCOUNT, domain_id, options \\ []) do
    response = Client.get(client, Client.versioned("#{account_id}/domains/#{domain_id}"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> to_struct(Domain)
  end

  #@spec to_struct(Enum.t, module | map) :: map
  #def to_struct(kw, struct), do: struct(struct, kw)

  @spec to_struct(Enum.t, module | map) :: map
  def to_struct(kw, struct) do
    res = struct(struct)
    Map.keys(res)
    |> Enum.filter(fn(x) -> Map.has_key?(kw, to_string(x)) end)
    |> Enum.reduce(res, fn(x, acc) -> Map.put(acc, x, kw[to_string(x)]) end)
  end

end
