defmodule Dnsimple.Zones do
  @moduledoc """
  Handles communication with zone and zone record related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/zones/
  See https://developer.dnsimple.com/v2/zones/records/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Zone
  alias Dnsimple.ZoneRecord


  @doc """
  Returns the zones in the account.

  See: https://developer.dnsimple.com/v2/zones/#list
  """
  @spec list_zones(Client.t, String.t | integer, Keyword.t) :: Response.t
  def list_zones(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones")

    List.get(client, url, options)
    |> Response.parse(Zone)
  end

  @spec zones(Client.t, String.t | integer, Keyword.t) :: Response.t
  defdelegate zones(client, account_id, options \\ []), to: __MODULE__, as: :list_zones


  @doc """
  Returns a zone in the account.

  See: https://developer.dnsimple.com/v2/zones/#get
  """
  @spec get_zone(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_zone(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}")

    Client.get(client, url, options)
    |> Response.parse(Zone)
  end

  @spec zone(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate zone(client, account_id, zone_id, options \\ []), to: __MODULE__, as: :get_zone


  @doc """
  Returns the records in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#list
  """
  @spec list_zone_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def list_zone_records(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records")

    List.get(client, url, options)
    |> Response.parse(ZoneRecord)
  end

  @spec zone_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate zone_records(client, account_id, zone_id, options \\ []), to: __MODULE__, as: :list_zone_records


  @doc """
  Returns a record of the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#get
  """
  @spec get_zone_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  def get_zone_record(client, account_id, zone_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}")

    Client.get(client, url, options)
    |> Response.parse(Dnsimple.ZoneRecord)
  end

  @spec zone_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  defdelegate zone_record(client, account_id, zone_id, record_id, options \\ []), to: __MODULE__, as: :get_zone_record


  @doc """
  Creates a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#create
  """
  @spec create_zone_record(Client.t, String.t | integer, String.t | integer, Keyword.t, Keyword.t) :: Response.t
  def create_zone_record(client, account_id, zone_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records")

    Client.post(client, url, attributes, options)
    |> Response.parse(ZoneRecord)
  end


  @doc """
  Updates a record of the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#update
  """
  @spec update_zone_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t, Keyword.t) :: Response.t
  def update_zone_record(client, account_id, zone_id, record_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}")

    Client.patch(client, url, attributes, options)
    |> Response.parse(ZoneRecord)
  end


  @doc """
  Deletes a record from the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#delete
  """
  @spec delete_zone_record(Client.t, String.t, String.t, integer, Keyword.t) :: Response.t
  def delete_zone_record(client, account_id, zone_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
