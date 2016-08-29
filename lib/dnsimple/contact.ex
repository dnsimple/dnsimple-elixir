defmodule Dnsimple.Contact do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.ListOptions

  @moduledoc """
  Represents a DNSimple contact and the operations you can perform with them.

  See: https://developer.dnsimple.com/v2/contacts/
  """

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    label: String.t,
    first_name: String.t,
    last_name: String.t,
    email: String.t,
    phone: String.t,
    fax: String.t,
    address1: String.t,
    address2: String.t,
    city: String.t,
    state_province: String.t,
    postal_code: String.t,
    country: String.t,
    job_title: String.t,
    organization_name: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(
   id account_id label first_name last_name email phone fax address1 address2
   city state_province postal_code country job_title organization_name
   created_at updated_at
  )a


  @doc """
  Lists the contacts in the account.

  See https://developer.dnsimple.com/v2/contacts/#list
  """
  @spec contacts(Client.t, String.t | integer) :: Response.t
  def contacts(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts")
    {headers, opts} = Client.headers(options)

    Client.get(client, url, headers, ListOptions.prepare(opts))
    |> Response.parse(__MODULE__)
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
    |> Response.parse(__MODULE__)
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
    |> Response.parse(__MODULE__)
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
    |> Response.parse(__MODULE__)
  end

end
