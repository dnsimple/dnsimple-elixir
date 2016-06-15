defmodule Dnsimple.DomainsService do
  @moduledoc """
  DomainsService handles communication with the domain related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.ListOptions
  alias Dnsimple.Response
  alias Dnsimple.Domain


  @doc """
  Lists the domains.

  See https://developer.dnsimple.com/v2/domains/#list
  """
  @spec domains(Client.t, String.t | integer) :: Response.t
  def domains(client, account_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/domains"), headers, ListOptions.prepare(opts))
    |> Response.parse(Domain)
  end

  @doc """
  Creates a new domain in the account.

  See https://developer.dnsimple.com/v2/domains/#list
  """
  @spec create_domain(Client.t, String.t | integer, map, Keyword.t) :: Response.t
  def create_domain(client, account_id, attributes, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.post(client, Client.versioned("/#{account_id}/domains"), attributes, headers, opts)
    |> Response.parse(Domain)
  end

  @doc """
  Get a domain.

  See https://developer.dnsimple.com/v2/domains/#get
  """
  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def domain(client, account_id, domain_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/domains/#{domain_id}"), headers, opts)
    |> Response.parse(Domain)
  end

  @doc """
  PERMANENTLY deletes a domain from the account.

  See https://developer.dnsimple.com/v2/domains/#delete
  """
  @spec delete_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_domain(client, account_id, domain_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.delete(client, Client.versioned("/#{account_id}/domains/#{domain_id}"), headers, opts)
    |> Response.parse(nil)
  end

end
