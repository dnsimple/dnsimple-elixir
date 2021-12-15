defmodule Dnsimple.Domains do
  @moduledoc """
  Provides functions to interact with the
  [domain endpoints](https://developer.dnsimple.com/v2/domains/).
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Domain
  alias Dnsimple.Dnssec
  alias Dnsimple.DelegationSignerRecord
  alias Dnsimple.EmailForward
  alias Dnsimple.Push
  alias Dnsimple.Collaborator

  @doc """
  Lists the domains in an account.

  See:
  - https://developer.dnsimple.com/v2/domains/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.list_domains(client, account_id = 1010)
      {:ok, response} = Dnsimple.Domains.list_domains(client, account_id = 1010, sort: "name:asc")
      {:ok, response} = Dnsimple.Domains.list_domains(client, account_id = 1010, per_page: 50, page: 4)
      {:ok, response} = Dnsimple.Domains.list_domains(client, account_id = 1010, filter: [name_like: ".com"])

  """
  @spec list_domains(Client.t, String.t | integer) :: {:ok|:error, Response.t}
  def list_domains(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Domain{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  List all domains in an account automatically paginating if necessary.

  This function will automatically page through all pages, returning all domains.
  It will respect the provided sorting and filtering options.

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.all_domains(client, account_id = 1010)
      {:ok, response} = Dnsimple.Domains.all_domains(client, account_id = 1010, sort: "name:asc")
      {:ok, response} = Dnsimple.Domains.all_domains(client, account_id = 1010, filter: [name_like: ".com"])

  """
  @spec all_domains(Client.t, String.t | integer, Keyword.t) :: {:ok|:error, [Domain.t]}
  def all_domains(client, account_id, options \\ []) do
    Listing.get_all(__MODULE__, :list_domains, [client, account_id, options])
  end


  @doc """
  Returns a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.get_domain(client, account_id = 1010, domain_id = 123)
      {:ok, response} = Dnsimple.Domains.get_domain(client, account_id = 1010, domain_id = "example.com")

  """
  @spec get_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_domain(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Domain{}})
  end


  @doc """
  Creates a new domain in the account.

  This won't register the domain and will only add it to the account.
  To register a domain please use `Dnsimple.Registrar.register_domain/5`.

  See:
  - https://developer.dnsimple.com/v2/domains/#create

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.create_domain(client, account_id = 1010, %{name: "example.io"})

  """
  @spec create_domain(Client.t, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def create_domain(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Domain{}})
  end


  @doc """
  Deletes a domain from an account.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/domains/#delete

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.delete_domain(client, account_id = 1010, domain_id = 237)
      {:ok, response} = Dnsimple.Domains.delete_domain(client, account_id = 1010, domain_id = "example.io")

  """
  @spec delete_domain(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_domain(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Enable DNSSEC for the domain in the account.

  See:
  - https://developer.dnsimple.com/v2/dnssec/#enable

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.enable_dnssec(client, account_id = 1000, domain_id = 123)
      {:ok, response} = Dnsimple.Domains.enable_dnssec(client, account_id = 1000, domain_id = "example.io")

  """
  @spec enable_dnssec(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def enable_dnssec(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/dnssec")

    Client.post(client, url, Client.empty_body(), options)
    |> Response.parse(%{"data" => %Dnssec{}})
  end


  @doc """
  Disable DNSSEC for the domain in the account.

  See:
  - https://developer.dnsimple.com/v2/dnssec/#disable

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.disable_dnssec(client, account_id = 1000, domain_id = 123)
      {:ok, response} = Dnsimple.Domains.disable_dnssec(client, account_id = 1000, domain_id = "example.io")

  """
  @spec disable_dnssec(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def disable_dnssec(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/dnssec")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Get the DNSSEC status for the domain in the account.

  See:
  - https://developer.dnsimple.com/v2/dnssec/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.get_dnssec(client, account_id = 1000, domain_id = 123)
      {:ok, response} = Dnsimple.Domains.get_dnssec(client, account_id = 1000, domain_id = "example.io")

  """
  @spec get_dnssec(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_dnssec(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/dnssec")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Dnssec{}})
  end


  @doc """
  Lists the delegation signer records for the domain.

  See:
  - https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.list_delegation_signer_records(client, account_id = 1000, domain_id = 123)
      {:ok, response} = Dnsimple.Domains.list_delegation_signer_records(client, account_id = 1000, domain_id = "example.io")

  """
  @spec list_delegation_signer_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_delegation_signer_records(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/ds_records")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%DelegationSignerRecord{}], "pagination" => %Response.Pagination{}})
  end

  @doc """
  Creates a delegation signer record for a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-create

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.create_delegation_signer_record(client, account_id = 1010, domain_id = "example.com", %{
        algorithm: "13",
        digest: "684a1f049d7d082b7f98691657da5a65764913df7f065f6f8c36edf62d66ca03",
        digest_type: "2",
        public_key: nil,
        keytag: "2371"
      })

  """
  @spec create_delegation_signer_record(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def create_delegation_signer_record(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/ds_records")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DelegationSignerRecord{}})
  end

  @doc """
  Returns a delegation signer record of a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.get_delegation_signer_record(client, account_id = 1010, domain_id = "example.com", ds_record_id = 123)

  """
  @spec get_delegation_signer_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_delegation_signer_record(client, account_id, domain_id, ds_record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DelegationSignerRecord{}})
  end


  @doc """
  Deletes an delegation signer record from a domain.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/domains/dnssec/#ds-record-delete

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.delete_delegation_signer_record(client, account_id = 1010, domain_id = "example.com", ds_record_id = 123)

  """
  @spec delete_delegation_signer_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_delegation_signer_record(client, account_id, domain_id, ds_record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/ds_records/#{ds_record_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Lists the email forwards of a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/email-forwards/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = 23)
      {:ok, response} = Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = "example.com")
      {:ok, response} = Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = "example.com", sort: "to:asc")
      {:ok, response} = Dnsimple.Domains.list_email_forwards(client, account_id = 1010, domain_id = "example.com", per_page: 5, page: 1)

  """
  @spec list_email_forwards(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_email_forwards(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%EmailForward{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Creates an email forward for a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/email-forwards/#create

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.create_email_forward(client, account_id = 1010, domain_id = "example.com", %{
        from: "jacegu@example.com",
        to: "me@provider.com",
      })

  """
  @spec create_email_forward(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def create_email_forward(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %EmailForward{}})
  end


  @doc """
  Returns an email forward of a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/email-forwards/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.get_email_forward(client, account_id = 1010, domain_id = "example.com", email_forward_id = 123)

  """
  @spec get_email_forward(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_email_forward(client, account_id, domain_id, email_forward_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %EmailForward{}})
  end


  @doc """
  Deletes an email forward of a domain.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/domains/email-forwards/#delete

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.delete_email_forward(client, account_id = 1010, domain_id = "example.com", email_forward_id = 123)

  """
  @spec delete_email_forward(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_email_forward(client, account_id, domain_id, email_forward_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/email_forwards/#{email_forward_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Returns the pending pushes in the account.

  See:
  - https://developer.dnsimple.com/v2/domains/pushes#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.list_pushes(client, account_id = 1010)

  """
  @spec list_pushes(Client.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_pushes(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/pushes")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Push{}]})
  end


  @doc """
  Initiates the push of a domain to a different account.

  See:
  - https://developer.dnsimple.com/v2/domains/pushes#initiate

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.initiate_push(client, account_id = 1010, domain_id = "example.com", %{
        new_account_email: "other@example.com",
      })

  """
  @spec initiate_push(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def initiate_push(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/pushes")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Push{}})
  end


  @doc """
  Accepts a pending push. Requires a `contact_id` to be provided that
  will be used as the domain contact.

  See:
  - https://developer.dnsimple.com/v2/domains/pushes#accept

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.accept_push(client, account_id = 1010, push_id = 6789, %{
        contact_id: 123
      })

  """
  @spec accept_push(Client.t, String.t | integer, integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def accept_push(client, account_id, push_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/pushes/#{push_id}")

    Client.post(client, url, attributes, options)
    |> Response.parse(nil)
  end


  @doc """
  Rejects a pending push.

  See:
  - https://developer.dnsimple.com/v2/domains/pushes#reject

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.reject_push(client, account_id = 1010, push_id = 6789)

  """
  @spec reject_push(Client.t, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def reject_push(client, account_id, push_id, options \\ []) do
    url = Client.versioned("/#{account_id}/pushes/#{push_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Lists the collaborators of the domain.

  See:
  - https://developer.dnsimple.com/v2/domains/collaborators/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.list_collaborators(client, account_id = 1010, domain_id = "example.com")

  """
  @spec list_collaborators(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_collaborators(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/collaborators")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Collaborator{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Adds a collaborator to the domain.

  See:
  - https://developer.dnsimple.com/v2/domains/collaborators/#add

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.add_collaborator(client, account_id = 1010, domain_id = "example.com", %{
        email: "existing-user@example.com"
      })

  """
  @spec add_collaborator(Client.t, String.t | integer, String.t | integer, map(), keyword()) :: {:ok|:error, Response.t}
  def add_collaborator(client, account_id, domain_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/collaborators")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Collaborator{}})
  end


  @doc """
  Removes a collaborator from the domain.

  See:
  - https://developer.dnsimple.com/v2/domains/collaborators/#remove

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Domains.remove_collaborator(client, account_id = 1010, domain_id = "example.com", collaborator_id = 100)

  """
  @spec remove_collaborator(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def remove_collaborator(client, account_id, domain_id, collaborator_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/collaborators/#{collaborator_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
