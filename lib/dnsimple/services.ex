defmodule Dnsimple.Services do
  @moduledoc """
  DomainServicesService handles communication with the DNSimple
  API responsible for applying one-click services to domains.

  @see https://developer.dnsimple.com/v2/services/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Service

  @doc """
  List applied services.

  See https://developer.dnsimple.com/v2/services/domains/#applied
  """
  @spec applied_services(Client.t, String.t | integer, String.t | integer) :: Response.t
  def applied_services(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services")

    Client.get_list(client, url, options)
    |> Response.parse(Service)
  end

  @doc """
  Apply a service to a domain

  See https://developer.dnsimple.com/v2/services/domains/#apply
  """
  @spec apply_service(Client.t, String.t | integer, String.t | integer, String.t | integer) :: Response.t
  def apply_service(client, account_id, domain_id, service_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services/#{service_id}")

    Client.post2(client, url, _attributes = nil, options)
    |> Response.parse(nil)
  end

  @doc """
  Unapply a service previously applied to a domain

  See https://developer.dnsimple.com/v2/services/domains/#unapply
  """
  @spec unapply_service(Client.t, String.t | integer, String.t | integer, String.t | integer) :: Response.t
  def unapply_service(client, account_id, domain_id, service_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/services/#{service_id}")

    Client.delete2(client, url, options)
    |> Response.parse(nil)
  end

end
