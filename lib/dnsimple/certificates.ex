defmodule Dnsimple.Certificates do
  @moduledoc """
  Provides functions to interact with the
  [SSL certificate related endpoints](https://developer.dnsimple.com/v2/domains/certificates/)
  of the DNSimple API.
  """

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Certificate

  @doc """
  List certificates for a domain in an account.

  See:
  - https://developer.dnsimple.com/v2/domains/certificates/#list

  ## Examples:
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Certificates.list_certificates(client, account_id = "1010", domain_id = "example.com")
  Dnsimple.Certificates.list_certificates(client, account_id = "1010", domain_id = "example.com", page: 2, per_page: 10)
  Dnsimple.Certificates.list_certificates(client, account_id = "1010", domain_id = "example.com", sort: "expires_on:desc")
  ```
  """
  @spec list_certificates(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def list_certificates(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Certificate{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns information about a certificate.

  See:
  - https://developer.dnsimple.com/v2/domains/certificates/#get

  ## Examples
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Certificates.get_certificate(client, account_id = "1010", domain_id = "example.com")
  ```
  """
  @spec get_certificate(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Returns a certificate.

  See:
  - https://developer.dnsimple.com/v2/domains/certificates/#download

  ## Examples
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Certificates.download_certificate(client, account_id = "1010", domain_id = "example.com")
  ```
  """
  @spec download_certificate(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def download_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Returns a certificate's private key.

  See:
  - https://developer.dnsimple.com/v2/domains/certificates/#get-private-key

  ## Examples
  ```
  client = %Dnsimple.Client{access_token: "a1b2c3d4"}
  Dnsimple.Certificates.get_certificate_private_key(client, account_id = "1010", domain_id = "example.com")
  ```
  """
  @spec get_certificate_private_key(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_certificate_private_key(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end

end
