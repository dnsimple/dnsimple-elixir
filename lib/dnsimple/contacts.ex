defmodule Dnsimple.Contacts do
  @moduledoc """
  Provides functions to interact with the
  [contact related endpoints](https://developer.dnsimple.com/v2/contacts/)
  of the DNSimple API.
  """

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Contact

  @doc """
  Lists the contacts in an account.

  See:
  - https://developer.dnsimple.com/v2/contacts/#list

  ## Examples:
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Contacts.list_contacts(client, account_id = "1010")
  Dnsimple.Contacts.list_contacts(client, account_id = "1010")
  Dnsimple.Contacts.list_contacts(client, account_id = "1010", sort: "email:desc")
  ```
  """
  @spec list_contacts(Client.t, String.t | integer) :: Response.t
  def list_contacts(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Contact{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Gets a contact in an account.

  See:
  - https://developer.dnsimple.com/v2/contacts/#get

  ## Examples:
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Contacts.get_contact(client, account_id = "1010", contact_id = "123")
  ```
  """
  @spec get_contact(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_contact(client, account_id, contact_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts/#{contact_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Contact{}})
  end


  @doc """
  Creates a contact in an account.

  See:
  - https://developer.dnsimple.com/v2/contacts/#create

  ## Examples:
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Contacts.create_contact(client, account_id = "1010", %{
    first_name: "John",
    last_name: "Doe",
    address1: "Italian street, 10",
    city: "Roma",
    state_province: "RM",
    postal_code: "00100",
    country: "IT",
    email: "john.doe@email.com",
    phone: "+18001234567",
    fax: "+18011234567",
  })
  ```
  """
  @spec create_contact(Client.t, String.t | integer, Keyword.t, Keyword.t) :: Response.t
  def create_contact(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Contact{}})
  end


  @doc """
  Updates a contact in an account.

  See:
  - https://developer.dnsimple.com/v2/contacts/#update

  ## Examples:
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Contacts.update_contact(client, account_id = "1010", contact_id = "123", %{
    email: "johndoe@email-provider.com",
  })
  ```
  """
  @spec update_contact(Client.t, String.t | integer, String.t | integer, Keyword.t, Keyword.t) :: Response.t
  def update_contact(client, account_id, contact_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts/#{contact_id}")

    Client.patch(client, url, attributes, options)
    |> Response.parse(%{"data" => %Contact{}})
  end


  @doc """
  Deletes a contact in an account.

  See:
  - https://developer.dnsimple.com/v2/contacts/#delete

  ## Examples:
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Contacts.delete_contact(client, account_id = "1010", contact_id = "123")
  """
  @spec delete_contact(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_contact(client, account_id, contact_id, options \\ []) do
    url = Client.versioned("/#{account_id}/contacts/#{contact_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
