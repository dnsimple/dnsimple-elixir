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
  Lists the zones in the account.

  See: https://developer.dnsimple.com/v2/zones/#list
  """
  @spec zones(Client.t, String.t, Keyword.t) :: Response.t
  def zones(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones")

    List.get(client, url, options)
    |> Response.parse(Zone)
  end

  @doc """
  Gets a zone in the account.

  See: https://developer.dnsimple.com/v2/zones/#get
  """
  @spec zone(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def zone(client, account_id, zone_name, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}")

    Client.get(client, url, options)
    |> Response.parse(Zone)
  end


  @doc """
  Lists the records in a zone.

  See: https://developer.dnsimple.com/v2/zones/records/#list
  """
  @spec records(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def records(client, account_id, zone_name, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records")

    List.get(client, url, options)
    |> Response.parse(ZoneRecord)
  end

  @doc """
  Creates a record in a zone.

  See: https://developer.dnsimple.com/v2/zones/records/#create
  """
  @spec create_record(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def create_record(client, account_id, zone_name, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records")

    Client.post(client, url, attributes, options)
    |> Response.parse(ZoneRecord)
  end

  @doc """
  Gets a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#get
  """
  @spec record(Client.t, String.t, String.t, integer, Keyword.t) :: Response.t
  def record(client, account_id, zone_name, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records/#{record_id}")

    Client.get(client, url, options)
    |> Response.parse(Dnsimple.ZoneRecord)
  end

  @doc """
  Updates a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#update
  """
  @spec update_record(Client.t, String.t, String.t, integer, Keyword.t, Keyword.t) :: Response.t
  def update_record(client, account_id, zone_name, record_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records/#{record_id}")

    Client.patch(client, url, attributes, options)
    |> Response.parse(ZoneRecord)
  end

  @doc """
  Deletes a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#delete
  """
  @spec delete_record(Client.t, String.t, String.t, integer, Keyword.t) :: Response.t
  def delete_record(client, account_id, zone_name, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records/#{record_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
