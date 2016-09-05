defmodule Dnsimple.Domains do
  @moduledoc """
  The Domains module handles communication with the domain related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/domains/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Domain


  @doc """
  Lists the domains.

  See https://developer.dnsimple.com/v2/domains/#list
  """
  @spec domains(Client.t, String.t | integer) :: Response.t
  def domains(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains")

    List.get(client, url, options)
    |> Response.parse(Domain)
  end

  @doc """
  List all domains from the account. This function will automatically
  page through to the end of the list, returning all domain objects.
  """
  @spec all_domains(Client.t, String.t | integer, Keyword.t) :: [Domain.t]
  def all_domains(client, account_id, options \\ []) do
    new_options = Keyword.merge([page: 1], options)
    all_domains(client, account_id, new_options, [])
  end

  defp all_domains(client, account_id, options, domain_list) do
    {:ok, response} = domains(client, account_id, options)
    all_domains(client, account_id, Keyword.put(options, :page, options[:page] + 1), domain_list ++ response.data, response.pagination.total_pages - options[:page])
  end

  defp all_domains(_, _, _, domain_list, 0) do
    domain_list
  end
  defp all_domains(client, account_id, options, domain_list, _) do
    all_domains(client, account_id, options, domain_list)
  end

  @doc """
  Creates a new domain in the account.

  See https://developer.dnsimple.com/v2/domains/#create
  """
  @spec create_domain(Client.t, String.t | integer, map, Keyword.t) :: Response.t
  def create_domain(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains")

    Client.post(client, url, attributes, options)
    |> Response.parse(Domain)
  end

  @doc """
  Get a domain.

  See https://developer.dnsimple.com/v2/domains/#get
  """
  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def domain(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}")

    Client.get(client, url, options)
    |> Response.parse(Domain)
  end

  @doc """
  PERMANENTLY deletes a domain from the account.

  See https://developer.dnsimple.com/v2/domains/#delete
  """
  @spec delete_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_domain(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

  @doc """
  Resets the domain token.

  See https://developer.dnsimple.com/v2/domains/#reset-token
  """
  @spec reset_domain_token(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def reset_domain_token(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/token")

    Client.post(client, url, Client.empty_body, options)
    |> Response.parse(Domain)
  end

end
