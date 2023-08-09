defmodule Dnsimple.Zones do
  @moduledoc """
  Provides functions to interact with the
  [zone endpoints](https://developer.dnsimple.com/v2/zones/).

  See:
  - https://developer.dnsimple.com/v2/zones/
  - https://developer.dnsimple.com/v2/zones/records/
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Zone
  alias Dnsimple.ZoneFile
  alias Dnsimple.ZoneDistribution
  alias Dnsimple.ZoneRecord

  @doc """
  Returns the zones in the account.

  See:
  - https://developer.dnsimple.com/v2/zones/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.list_zones(client, account_id = 1010)
      {:ok, response} = Dnsimple.Zones.list_zones(client, account_id = 1010, page: 2, per_page: 10)
      {:ok, response} = Dnsimple.Zones.list_zones(client, account_id = 1010, sort: "name:desc")
      {:ok, response} = Dnsimple.Zones.list_zones(client, account_id = 1010, filter: [name_like: ".es"])

  """
  @spec list_zones(Client.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_zones(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Zone{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a zone.

  See:
  - https://developer.dnsimple.com/v2/zones/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.get_zone(client, account_id = 1010, zone_id = 12)
      {:ok, response} = Dnsimple.Zones.get_zone(client, account_id = 1010, zone_id = "example.com")

  """
  @spec get_zone(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_zone(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Zone{}})
  end


  @doc """
  Returns the zone file of the zone.

  See:
  - https://developer.dnsimple.com/v2/zones/#file

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.get_zone_file(client, account_id = 1010, zone_id = 12)
      {:ok, response} = Dnsimple.Zones.get_zone_file(client, account_id = 1010, zone_id = "example.com")

  """
  @spec get_zone_file(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_zone_file(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/file")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %ZoneFile{}})
  end


  @doc """
  Returns the distribution status of a zone.

  See:
  - https://developer.dnsimple.com/v2/zones/#checkZoneDistribution

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.check_zone_distribution(client, account_id = 1010, zone_id = 12)
      {:ok, response} = Dnsimple.Zones.check_zone_distribution(client, account_id = 1010, zone_id = "example.com")

  """
  @spec check_zone_distribution(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def check_zone_distribution(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/distribution")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %ZoneDistribution{}})
  end

  @doc """
  Returns the distribution status of a zone record.

  See:
  - https://developer.dnsimple.com/v2/zones/#checkZoneRecordDistribution

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.check_zone_record_distribution(client, account_id = 1010, zone_id = 12, record_id = 999)
      {:ok, response} = Dnsimple.Zones.check_zone_record_distribution(client, account_id = 1010, zone_id = "example.com", record_id = 999)

  """
  @spec check_zone_record_distribution(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def check_zone_record_distribution(client, account_id, zone_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}/distribution")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %ZoneDistribution{}})
  end


  @doc """
  Returns the records in the zone.

  See:
  - https://developer.dnsimple.com/v2/zones/records/#listZoneRecords

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.list_zone_records(client, account_id = 1010, zone_id = "example.com")
      {:ok, response} = Dnsimple.Zones.list_zone_records(client, account_id = 1010, zone_id = 12, page: 2, per_page: 10)
      {:ok, response} = Dnsimple.Zones.list_zone_records(client, account_id = 1010, zone_id = "example.com", sort: "type:asc")
      {:ok, response} = Dnsimple.Zones.list_zone_records(client, account_id = 1010, zone_id = 12, filter: [type: "A", name: ""])

  """
  @spec list_zone_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_zone_records(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%ZoneRecord{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a zone record.

  See:
  - https://developer.dnsimple.com/v2/zones/records/#getZoneRecord

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.get_zone_record(client, account_id = 1010, zone_id = 12, record_id = 345)
      {:ok, response} = Dnsimple.Zones.get_zone_record(client, account_id = 1010, zone_id = "example.com", record_id = 123)

  """
  @spec get_zone_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_zone_record(client, account_id, zone_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %ZoneRecord{}})
  end


  @doc """
  Creates a record in the zone.

  See:
  - https://developer.dnsimple.com/v2/zones/records/#createZoneRecord

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.create_zone_record(client, account_id = 1010, zone_id = "example.com", %{
        name: "www",
        type: "CNAME",
        content: "example.com",
        ttl: 3600,
      })

  """
  @spec create_zone_record(Client.t, String.t | integer, String.t | integer, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def create_zone_record(client, account_id, zone_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %ZoneRecord{}})
  end


  @doc """
  Updates a zone record.
  - https://developer.dnsimple.com/v2/zones/records/#updateZoneRecord

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.update_zone_record(client, account_id = 1010, zone_id = "example.com", record_id = 1, %{
        ttl: 600
      })

  """
  @spec update_zone_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def update_zone_record(client, account_id, zone_id, record_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}")

    Client.patch(client, url, attributes, options)
    |> Response.parse(%{"data" => %ZoneRecord{}})
  end


  @doc """
  Deletes a record from the zone.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/zones/records/#deleteZoneRecord

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.delete_zone_record(client, account_id = 1010, zone_id = 12, record_id = 1)
      {:ok, response} = Dnsimple.Zones.delete_zone_record(client, account_id = 1010, zone_id = "example.com", record_id = 1)

  """
  @spec delete_zone_record(Client.t, String.t, String.t, integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_zone_record(client, account_id, zone_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/records/#{record_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

  @doc """
  Activate DNS resolution for the zone in the account.

  See:
  - https://developer.dnsimple.com/v2/zones/#activateZoneService

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.activate_dns(client, account_id = 1010, zone_id = "example.com")

  """
  @spec activate_dns(Client.t, integer | String.t, integer | String.t, Keyword.t) :: {:ok|:error, Response.t}
  def activate_dns(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/activation")

    Client.put(client, url, Client.empty_body(), options)
    |> Response.parse(%{"data" => %Zone{}})
  end

  @doc """
  Deactivate DNS resolution for the zone in the account.

  See:
  - https://developer.dnsimple.com/v2/zones/#deactivateZoneService

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Zones.deactivate_dns(client, account_id = 1010, zone_id = "example.com")

  """
  @spec deactivate_dns(Client.t, integer | String.t, integer | String.t, Keyword.t) :: {:ok|:error, Response.t}
  def deactivate_dns(client, account_id, zone_id, options \\ []) do
    url = Client.versioned("/#{account_id}/zones/#{zone_id}/activation")

    Client.delete(client, url, options)
    |> Response.parse(%{"data" => %Zone{}})
  end
end
