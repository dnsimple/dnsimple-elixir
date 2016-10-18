defmodule Dnsimple.Domains do
  @moduledoc """
  This module provides functions to interact with the domain related endpoints.

  See https://developer.dnsimple.com/v2/domains/
  """

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Domain
  alias Dnsimple.EmailForward
  alias Dnsimple.Push
  alias Dnsimple.Collaborator

  @doc """
  Lists the domains.

  See https://developer.dnsimple.com/v2/domains/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.list_domains(client, account_id = 1010)
    Dnsimple.Domains.list_domains(client, account_id = 1010, sort: "name:asc")
    Dnsimple.Domains.list_domains(client, account_id = 1010, per_page: 50, page: 4)
    Dnsimple.Domains.list_domains(client, account_id = 1010, filter: [name_like: ".com"])

  """
  @spec list_domains(Client.t, String.t | integer) :: Response.t
  def list_domains(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Domain{}], "pagination" => %Response.Pagination{}})
  end

  @spec domains(Client.t, String.t | integer) :: Response.t
  defdelegate domains(client, account_id, options \\ []), to: __MODULE__, as: :list_domains


  @doc """
  List all domains from the account.

  This function will automatically page through to the end of the list,
  returning all domains. It will respect the provided sorting and filtering
  options.

  ## Examples:

    Dnsimple.Domains.all_domains(client, account_id = 1010)
    Dnsimple.Domains.all_domains(client, account_id = 1010, sort: "name:asc")
    Dnsimple.Domains.all_domains(client, account_id = 1010, filter: [name_like: ".com"])

  """
  @spec all_domains(Client.t, String.t | integer, Keyword.t) :: [Domain.t]
  def all_domains(client, account_id, options \\ []) do
    Listing.get_all(__MODULE__, :list_domains, [client, account_id, options])
  end


  @doc """
  Get a domain.

  See https://developer.dnsimple.com/v2/domains/#get

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.get_domain(client, account_id = 1010, domain_id = 123)
    Dnsimple.Domains.get_domain(client, account_id = 1010, domain_id = "example.com")

  """
  @spec get_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_domain(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Domain{}})
  end

  @spec domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate domain(client, account_id, domain_id, options \\ []), to: __MODULE__, as: :get_domain


  @doc """
  Creates a new domain in the account.

  This won't register the domain and will only add the domain as hosted. To
  register a domain please use
  [`Dnsimple.Registrar.register_domain`](https://developer.dnsimple.com/v2/registrar/#register).

  See https://developer.dnsimple.com/v2/domains/#create

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.create_domain(client, account_id = 1010, %{name: "example.io"})

  """
  @spec create_domain(Client.t, String.t | integer, map, Keyword.t) :: Response.t
  def create_domain(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Domain{}})
  end


  @doc """
  PERMANENTLY deletes a domain from the account.

  See https://developer.dnsimple.com/v2/domains/#delete

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.delete_domain(client, account_id = 1010, domain_id = 237)
    Dnsimple.Domains.delete_domain(client, account_id = 1010, domain_id = "example.io")

  """
  @spec delete_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_domain(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Resets the domain API token used for authentication in APIv1.

  See https://developer.dnsimple.com/v2/domains/#reset-token

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.reset_domain_token(client, account_id = 1010, domain_id = 123)
    Dnsimple.Domains.reset_domain_token(client, account_id = 1010, domain_id = "example.io")

  """
  @spec reset_domain_token(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def reset_domain_token(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/token")

    Client.post(client, url, Client.empty_body, options)
    |> Response.parse(%{"data" => %Domain{}})
  end


  @doc """
  Lists the email forwards of a domain.

  See: https://developer.dnsimple.com/v2/domains/email-forwards/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = 23)
    Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = "example.com")
    Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = "example.com", sort: "to:asc")
    Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = "example.com", per_page: 5, page: 1)

  """
  @spec list_email_forwards(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def list_email_forwards(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%EmailForward{}], "pagination" => %Response.Pagination{}})
  end

  @spec email_forwards(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate email_forwards(client, account_id, domain_id, options \\ []), to: __MODULE__, as: :list_email_forwards


  @doc """
  Creates an email forward for a domain.

  See: https://developer.dnsimple.com/v2/domains/email-forwards/#create

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.create_email_forward(client, account_id = 1010, domain_id = "example.com", %{
      from: "jacegu@example.com",
      to: "me@provider.com",
    })

  """
  @spec create_email_forward(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: Response.t
  def create_email_forward(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %EmailForward{}})
  end


  @doc """
  Returns an email forward of a domain.

  See: https://developer.dnsimple.com/v2/domains/email-forwards/#get

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.get_email_forward(client, account_id = 1010, domain_id = "example.com", email_forward_id = 123)

  """
  @spec get_email_forward(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  def get_email_forward(client, account_id, domain_id, email_forward_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %EmailForward{}})
  end

  @spec email_forward(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  defdelegate email_forward(client, account_id, domain_id, email_forward_id, options \\ []), to: __MODULE__, as: :get_email_forward


  @doc """
  Deletes an email forward of a domain.

  See: https://developer.dnsimple.com/v2/domains/email-forwards/#delete

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.delete_email_forward(client, account_id = 1010, domain_id = "example.com", email_forward_id = 123)

  """
  @spec delete_email_forward(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  def delete_email_forward(client, account_id, domain_id, email_forward_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Returns the pending pushes in the account.

  See: https://developer.dnsimple.com/v2/domains/pushes#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.list_pushes(client, account_id = 1010)

  """
  @spec list_pushes(Client.t, String.t | integer, Keyword.t) :: Response.t
  def list_pushes(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/pushes")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Push{}]})
  end

  @spec pushes(Client.t, String.t | integer, Keyword.t) :: Response.t
  defdelegate pushes(client, account_id, options \\ []), to: __MODULE__, as: :list_pushes


  @doc """
  Initiates the push of a domain to a different account.

  See: https://developer.dnsimple.com/v2/domains/pushes#initiate

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.initiate_push(client, account_id = 1010, domain_id = "example.com", %{
      new_account_email: "other@example.com",
    })

  """
  @spec initiate_push(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: Response.t
  def initiate_push(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/pushes")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Push{}})
  end


  @doc """
  Accept a pending push. Requires a contact_id corresponding to the that will
  be used as the domain contact.

  See: https://developer.dnsimple.com/v2/domains/pushes#accept

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.accept_push(client, account_id = 1010, push_id = 6789, %{
      contact_id: 123,
    })

  """
  @spec accept_push(Client.t, String.t | integer, integer, map, Keyword.t) :: Response.t
  def accept_push(client, account_id, push_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/pushes/#{push_id}")

    Client.post(client, url, attributes, options)
    |> Response.parse(nil)
  end


  @doc """
  Rejects a pending push.

  See: https://developer.dnsimple.com/v2/domains/pushes#reject

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.reject_push(client, account_id = 1010, push_id = 6789)

  """
  @spec reject_push(Client.t, String.t | integer, integer, Keyword.t) :: Response.t
  def reject_push(client, account_id, push_id, options \\ []) do
    url = Client.versioned("/#{account_id}/pushes/#{push_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Lists the collaborators of the domain.

  See: https://developer.dnsimple.com/v2/domains/collaborators/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.list_collaborators(client, account_id = 1010, domain_id = "example.com")

  """
  @spec list_collaborators(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def list_collaborators(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/collaborators")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Collaborator{}], "pagination" => %Response.Pagination{}})
  end

  @spec collaborators(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate collaborators(client, account_id, domain_id, options \\ []), to: __MODULE__, as: :list_collaborators


  @doc """
  Adds a collaborator to the domain.

  See: https://developer.dnsimple.com/v2/domains/collaborators/#add

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Domains.add_collaborator(client, account_id = 1010, domain_id = "example.com", %{email: "existing-user@example.com"})

  """
  @spec add_collaborator(Client.t, String.t | integer, String.t | integer, Map.t, Keyword.t) :: Response.t
  def add_collaborator(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/collaborators")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Collaborator{}})
  end

end
