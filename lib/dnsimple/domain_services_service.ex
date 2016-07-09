defmodule Dnsimple.DomainServicesService do
  @moduledoc """
  DomainServicesService handles communication with the DNSimple
  API responsible for applying one-click services to domains.

  @see https://developer.dnsimple.com/v2/services/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.ListOptions
  alias Dnsimple.Response
  alias Dnsimple.Service

  @doc """
  List applied services.

  See https://developer.dnsimple.com/v2/services/domains/#applied
  """
  @spec applied_services(Client.t, String.t | integer, String.t | integer) :: Response.t
  def applied_services(client, account_id, domain_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/domains/#{domain_id}/services"), headers, ListOptions.prepare(opts))
    |> Response.parse(Service)
  end
end
