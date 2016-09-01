defmodule Dnsimple.Certificates do
  @moduledoc """
  This module handles communication with the DNSimple API responsible of
  handling SSL certificates.

  @see https://developer.dnsimple.com/v2/domains/certificates/
  """

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Certificate


  @doc """
  List certificates.

  See https://developer.dnsimple.com/v2/domains/certificates/#list
  """
  @spec certificates(Client.t, String.t | integer, String.t | integer) :: Response.t
  def certificates(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates")

    Client.get_list(client, url, options)
    |> Response.parse(Certificate)
  end

  @doc """
  Get a certificate.

  See https://developer.dnsimple.com/v2/domains/certificates/#get
  """
  @spec certificate(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}")

    Client.get(client, url, options)
    |> Response.parse(Certificate)
  end

  @doc """
  Download a certificate.

  See https://developer.dnsimple.com/v2/domains/certificates/#download
  """
  @spec download(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def download(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download")

    Client.get(client, url, options)
    |> Response.parse(Certificate)
  end

  @doc """
  Download a private key.

  See https://developer.dnsimple.com/v2/domains/certificates/#get-private-key
  """
  @spec private_key(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def private_key(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key")

    Client.get(client, url, options)
    |> Response.parse(Certificate)
  end

end
