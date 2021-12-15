defmodule Dnsimple.Services do
  @moduledoc """
  Provides functions to interact with the
  [one-click service endpoints](https://developer.dnsimple.com/v2/services/).

  See:
  - https://developer.dnsimple.com/v2/services
  - https://developer.dnsimple.com/v2/services/domains/
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Service

  @doc """
  Returns the list of available one-click services.

  See:
  - https://developer.dnsimple.com/v2/services/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.list_services(client)
      {:ok, response} = Dnsimple.Templates.list_services(client, sort: "short_name:desc")

  """
  @spec list_services(Client.t, Keyword.t) :: {:ok|:error, Response.t}
  def list_services(client, options \\ []) do
    url = Client.versioned("/services")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Service{settings: [%Service.Setting{}]}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a one-click service.

  See:
  - https://developer.dnsimple.com/v2/services/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.get_service(client, service_id = 1)
      {:ok, response} = Dnsimple.Templates.get_service(client, service_id = "wordpress")

  """
  @spec get_service(Client.t, integer | String.t, Keyword.t) :: {:ok|:error, Response.t}
  def get_service(client, service_id, options \\ []) do
    url = Client.versioned("/services/#{service_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Service{settings: [%Service.Setting{}]}})
  end


  @doc """
  Lists the one-click services already applied to a domain.

  See:
  - https://developer.dnsimple.com/v2/services/domains/#applied

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Services.applied_services(client, account_id = 1010, domain_id = "example.com")
      {:ok, response} = Dnsimple.Services.applied_services(client, account_id = 1010, domain_id = "example.com", page: 2)

  """
  @spec applied_services(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def applied_services(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Service{settings: [%Service.Setting{}]}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Apply a one-click service to a domain.

  See:
  - https://developer.dnsimple.com/v2/services/domains/#apply

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Services.apply_service(client, account_id = 1010, domain_id = "example.com", service_id = 12)
      {:ok, response} = Dnsimple.Services.apply_service(client, account_id = 1010, domain_id = "example.com", service_id = 27, %{
        %{settings: %{setting_name: "setting value"}}
      })

  """
  @spec apply_service(Client.t, String.t | integer, String.t | integer, String.t | integer, map(), keyword()) :: {:ok|:error, Response.t}
  def apply_service(client, account_id, domain_id, service_id, settings \\ %{}, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services/#{service_id}")

    Client.post(client, url, settings, options)
    |> Response.parse(nil)
  end


  @doc """
  Remove a one-click service previously applied to a domain.

  See:
  - https://developer.dnsimple.com/v2/services/domains/#unapply

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Services.unapply_service(client, account_id = 1010, domain_id = "example.com", service_id = 12)

  """
  @spec unapply_service(Client.t, String.t | integer, String.t | integer, String.t | integer, keyword()) :: {:ok|:error, Response.t}
  def unapply_service(client, account_id, domain_id, service_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services/#{service_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
