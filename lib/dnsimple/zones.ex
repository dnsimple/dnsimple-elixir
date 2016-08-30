defmodule Dnsimple.Zones do
  alias Dnsimple.Client
  alias Dnsimple.ListOptions
  alias Dnsimple.Response

  @doc """
  Lists the zones in the account.

  See: https://developer.dnsimple.com/v2/zones/#list
  """
  @spec list_zones(Client.t, String.t, Keyword.t) :: Response.t
  def list_zones(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, ListOptions.prepare(opts))
      |> Response.parse(Dnsimple.Zone)
  end

  @doc """
  Gets a zone in the account.

  See: https://developer.dnsimple.com/v2/zones/#get
  """
  @spec zone(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def zone(client, account_id, zone_name, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, opts)
      |> Response.parse(Dnsimple.Zone)
  end

  @doc """
  Lists the records in a zone.

  See: https://developer.dnsimple.com/v2/zones/records/#list
  """
  @spec list_records(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def list_records(client, account_id, zone_name, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, ListOptions.prepare(opts))
      |> Response.parse(Dnsimple.ZoneRecord)
  end

  @doc """
  Creates a record in a zone.

  See: https://developer.dnsimple.com/v2/zones/records/#create
  """
  @spec create_record(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def create_record(client, account_id, zone_name, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records")
    {headers, opts} = Client.headers(options)

    Client.post(client, url, attributes, headers, opts)
      |> Response.parse(Dnsimple.ZoneRecord)
  end

  @doc """
  Gets a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#get
  """
  @spec record(Client.t, String.t, String.t, integer, Keyword.t) :: Response.t
  def record(client, account_id, zone_name, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records/#{record_id}")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, opts)
      |> Response.parse(Dnsimple.ZoneRecord)
  end

  @doc """
  Updates a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#update
  """
  @spec update_record(Client.t, String.t, String.t, integer, Keyword.t, Keyword.t) :: Response.t
  def update_record(client, account_id, zone_name, record_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records/#{record_id}")
    {headers, opts} = Client.headers(options)

    Client.patch(client, url, attributes, headers, opts)
      |> Response.parse(Dnsimple.ZoneRecord)
  end

  @doc """
  Deletes a record in the zone.

  See: https://developer.dnsimple.com/v2/zones/records/#delete
  """
  @spec delete_record(Client.t, String.t, String.t, integer, Keyword.t) :: Response.t
  def delete_record(client, account_id, zone_name, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_name}/records/#{record_id}")
    {headers, opts} = Client.headers(options)

    Client.delete(client, url, headers, opts)
      |> Response.parse(nil)
  end

end
