defmodule Dnsimple.RecordsService do
  alias Dnsimple.Client
  alias Dnsimple.Record

  @spec record(Client.t, String.t | integer, integer, Keyword.t) :: Record.t
  def record(client, zone_id, record_id, options \\ []) do
    record(client, "_", zone_id, record_id, options)
  end

  @spec record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Record.t
  def record(client, account_id, zone_id, record_id, options) do
    response = Client.get(client, Client.versioned("#{account_id}/zones/#{zone_id}/records/#{record_id}"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> Dnsimple.Utils.single_to_struct(Record)
  end

  @spec records(Client.t, String.t | integer, Keyword.t) :: [Record.t]
  def records(client, zone_id, options \\ []) do
    records(client, "_", zone_id, options)
  end

  @spec records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: [Record.t]
  def records(client, account_id, zone_id, options) do
    response = Client.get(client, Client.versioned("#{account_id}/zones/#{zone_id}/records"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
    |> Dnsimple.Utils.collection_to_struct(Record)
  end

end
