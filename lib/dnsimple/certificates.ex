defmodule Dnsimple.Certificates do
  @moduledoc """
  This module provides functions to interact with the SSL certificate related 
  endpoints.

  See: https://developer.dnsimple.com/v2/domains/certificates/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Certificate

  @doc """
  Returns the list of certificates for the domain.

  See: https://developer.dnsimple.com/v2/domains/certificates/#list

  ## Examples:

    client     = %Dnsimple.Client{access_token: "a1b2c3d4"}
    account_id = "1010"
    domain_id  = "example.com"

    Dnsimple.Certificates.list_certificates(client, account_id, domain_id)
    Dnsimple.Certificates.list_certificates(client, account_id, domain_id, page: 2, per_page: 10)
    Dnsimple.Certificates.list_certificates(client, account_id, domain_id, sort: "expires_on:desc")

  """
  @spec list_certificates(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def list_certificates(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates")

    List.get(client, url, options)
    |> Response.parse(%{"data" => [%Certificate{}], "pagination" => %Response.Pagination{}})
  end

  @spec certificates(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate certificates(client, account_id, domain_id, options \\ []), to: __MODULE__, as: :list_certificates


  @doc """
  Returns the certificate data.

  See https://developer.dnsimple.com/v2/domains/certificates/#get

  ## Examples

    client     = %Dnsimple.Client{access_token: "a1b2c3d4"}
    account_id = "1010"
    domain_id  = "example.com"

    Dnsimple.Certificates.get_certificate(client, account_id, domain_id)

  """
  @spec get_certificate(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end

  @spec certificate(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate certificate(client, account_id, domain_id, certificate_id, options \\ []), to: __MODULE__, as: :get_certificate


  @doc """
  Returns the certificate.

  See https://developer.dnsimple.com/v2/domains/certificates/#download

  ## Examples

    client     = %Dnsimple.Client{access_token: "a1b2c3d4"}
    account_id = "1010"
    domain_id  = "example.com"

    Dnsimple.Certificates.download_certificate(client, account_id, domain_id)

  """
  @spec download_certificate(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def download_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Returns a certificate's private key.

  See https://developer.dnsimple.com/v2/domains/certificates/#get-private-key

  ## Examples

    client     = %Dnsimple.Client{access_token: "a1b2c3d4"}
    account_id = "1010"
    domain_id  = "example.com"

    Dnsimple.Certificates.get_certificate_private_key(client, account_id, domain_id)

  """
  @spec get_certificate_private_key(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_certificate_private_key(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end

  @spec certificate_private_key(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate certificate_private_key(client, account_id, domain_id, certificate_id, options \\ []), to: __MODULE__, as: :get_certificate_private_key

end
