defmodule Dnsimple.Services do
  @moduledoc """
  This module provides functions to interact with the service related endpoints.

  See https://developer.dnsimple.com/v2/services
  See https://developer.dnsimple.com/v2/services/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Service

  @doc """
  Returns the list of existing services.

  See https://developer.dnsimple.com/v2/services/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.list_services(client)
    Dnsimple.Templates.list_services(client, sort: "short_name:desc")

  """
  @spec list_services(Client.t, Keyword.t) :: Response.t
  def list_services(client, options \\ []) do
    url = Client.versioned("/services")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Service{settings: [%Service.Setting{}]}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a service.

  See https://developer.dnsimple.com/v2/services/#get

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.get_service(client, service_id = 1)
    Dnsimple.Templates.get_service(client, service_id = "wordpress")

  """
  @spec get_service(Client.t, integer | String.t, Keyword.t) :: Response.t
  def get_service(client, service_id, options \\ []) do
    url = Client.versioned("/services/#{service_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Service{settings: [%Service.Setting{}]}})
  end


  @doc """
  Lists the services already applied to a domain.

  See https://developer.dnsimple.com/v2/services/domains/#applied

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Services.applied_services(client, account_id = 1010, domain_id = "example.com")
    Dnsimple.Services.applied_services(client, account_id = 1010, domain_id = "example.com", page: 2)

  """
  @spec applied_services(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def applied_services(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Service{settings: [%Service.Setting{}]}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Apply a service to a domain.

  See https://developer.dnsimple.com/v2/services/domains/#apply

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Services.apply_service(client, account_id = 1010, domain_id = "example.com", service_id = 12)
    Dnsimple.Services.apply_service(client, account_id = 1010, domain_id = "example.com", service_id = 27, %{
      %{settings: %{setting_name: "setting value"}}
    })

  """
  @spec apply_service(Client.t, String.t | integer, String.t | integer, String.t | integer, Map.t, Keyword.t) :: Response.t
  def apply_service(client, account_id, domain_id, service_id, settings \\ %{}, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services/#{service_id}")

    Client.post(client, url, settings, options)
    |> Response.parse(nil)
  end


  @doc """
  Unapply a service previously applied to a domain.

  See https://developer.dnsimple.com/v2/services/domains/#unapply

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Services.unapply_service(client, account_id = 1010, domain_id = "example.com", service_id = 12)

  """
  @spec unapply_service(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def unapply_service(client, account_id, domain_id, service_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services/#{service_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
