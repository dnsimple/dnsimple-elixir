defmodule Dnsimple.DomainsService do
  @moduledoc """
  DomainsService handles communication with the domain related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Domain


  @doc """
  List the domains.

  See https://developer.dnsimple.com/v2/domains/#list
  """
  @spec domains(Client.t, String.t | integer, Keyword.t) :: Response.t
  def domains(client, account_id, options \\ []) do
    response = Client.get(client, Client.versioned("/#{account_id}/domains"), options)

    Response.new(response, Response.data(response, [Domain]))
  end

  @doc """
  Get a domain.

  See https://developer.dnsimple.com/v2/domains/#get
  """
  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def domain(client, account_id \\ Dnsimple.Client.__WILDCARD_ACCOUNT, domain_id, options \\ []) do
    response = Client.get(client, Client.versioned("/#{account_id}/domains/#{domain_id}"), options)

    Response.new(response, Response.data(response, Domain))
  end

end
