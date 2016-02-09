defmodule Dnsimple.ZonesService do
  alias Dnsimple.Client
  alias Dnsimple.Zone

  @spec zone(Client.t, String.t | integer, Keyword.t) :: Zone.t
  def zone(client, zone_id, options \\ []) do
    zone(client, "_", zone_id, options)
  end

  @spec zone(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Zone.t
  def zone(client, account_id, zone_id, options) do
    response = Client.get(client, Client.versioned("#{account_id}/zones/#{zone_id}"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> Dnsimple.Utils.single_to_struct(Zone)
  end
end
