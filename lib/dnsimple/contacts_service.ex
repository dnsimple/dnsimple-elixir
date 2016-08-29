defmodule Dnsimple.ContactsService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.ListOptions
  alias Dnsimple.Contact

  @moduledoc """
  Represents the operations that can be performed with contacts.

  See: https://developer.dnsimple.com/v2/contacts/
  """


  @doc """
  Lists the contacts in the account.

  See https://developer.dnsimple.com/v2/contacts/#list
  """
  @spec contacts(Client.t, String.t | integer) :: Response.t
  def contacts(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, ListOptions.prepare(opts))
    |> Response.parse(Contact)
  end

  @doc """
  Gets a contact in the account.

  See https://developer.dnsimple.com/v2/contacts/#get
  """
  @spec contact(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def contact(client, account_id, contact_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts/#{contact_id}")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, opts)
    |> Response.parse(Contact)
  end

  @doc """
  Creates a contact in the account.

  See https://developer.dnsimple.com/v2/contacts/#create
  """
  @spec create_contact(Client.t, String.t | integer, Keyword.t, Keyword.t) :: Response.t
  def create_contact(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts")
    {headers, opts} = Client.headers(options)

    Client.post(client, url, attributes, headers, opts)
    |> Response.parse(Contact)
  end


  @doc """
  Updates a contact in the account.

  See https://developer.dnsimple.com/v2/contacts/#update
  """
  @spec update_contact(Client.t, String.t | integer, String.t | integer, Keyword.t, Keyword.t) :: Response.t
  def update_contact(client, account_id, contact_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts/#{contact_id}")
    {headers, opts} = Client.headers(options)

    Client.patch(client, url, attributes, headers, opts)
    |> Response.parse(Contact)
  end

  @doc """
  Deletes a contact in the account.

  See https://developer.dnsimple.com/v2/contacts/#delete
  """
  @spec delete_contact(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_contact(client, account_id, contact_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts/#{contact_id}")
    {headers, opts} = Client.headers(options)

    Client.delete(client, url, headers, opts)
    |> Response.parse(nil)
  end

end
