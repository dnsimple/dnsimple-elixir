defmodule Dnsimple.Certificates do
  @moduledoc """
  Provides functions to interact with the
  [SSL certificate endpoints](https://developer.dnsimple.com/v2/certificates/).
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Certificate
  alias Dnsimple.CertificatePurchase
  alias Dnsimple.CertificateRenewal

  @doc """
  List certificates for a domain in the account.

  See:
  - https://developer.dnsimple.com/v2/certificates/#listCertificates

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.list_certificates(client, account_id = "1010", domain_id = "example.com")
      {:ok, response} = Dnsimple.Certificates.list_certificates(client, account_id = "1010", domain_id = "example.com", page: 2, per_page: 10)
      {:ok, response} = Dnsimple.Certificates.list_certificates(client, account_id = "1010", domain_id = "example.com", sort: "expiration:desc")

  """
  @spec list_certificates(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_certificates(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Certificate{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Get the details of a certificate.

  See:
  - https://developer.dnsimple.com/v2/certificates/#getCertificate

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.get_certificate(client, account_id = "1010", domain_id = "example.com")

  """
  @spec get_certificate(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Get the PEM-encoded certificate, along with the root certificate and intermediate chain.

  See:
  - https://developer.dnsimple.com/v2/certificates/#downloadCertificate

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.download_certificate(client, account_id = "1010", domain_id = "example.com")

  """
  @spec download_certificate(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def download_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/download")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Get the PEM-encoded certificate private key.

  See:
  - https://developer.dnsimple.com/v2/certificates/#getCertificatePrivateKey

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.get_certificate_private_key(client, account_id = "1010", domain_id = "example.com")

  """
  @spec get_certificate_private_key(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_certificate_private_key(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/#{certificate_id}/private_key")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Purchase a Let's Encrypt certificate.

  This method creates a new purchase order. The order ID should be used to
  request the issuance of the certificate using `#issue_letsencrypt_certificate`.

  See:
  - https://developer.dnsimple.com/v2/certificates/#purchaseLetsencryptCertificate

  ## Examples

      # Purchase a certificate for a single name
      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate(client, account_id = "1010", domain_id = "example.com", name: "www")
      purchase_id     = response.data.id

      # Purchase a certificate for multiple names (SAN)
      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate(client, account_id = "1010", domain_id = "example.com", alternate_names: ["example.com", "www.example.com", "status.example.com"])

      # Enable auto-renew on purchase
      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate(client, account_id = "1010", domain_id = "example.com", auto_renew: true)

      # Signature Algorithm
      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate(client, account_id = "1010", domain_id = "example.com", signature_algorithm: "RSA")

  """
  @spec purchase_letsencrypt_certificate(Client.t, String.t | integer, String.t | integer, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def purchase_letsencrypt_certificate(client, account_id, domain_id, attributes \\ %{}, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/letsencrypt")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %CertificatePurchase{}})
  end


  @doc """
  Issue a pending Let's Encrypt certificate order.

  Note that the issuance process is async. A successful response means the issuance
  request has been successfully acknowledged and queued for processing.

  See:
  - https://developer.dnsimple.com/v2/certificates/#issueLetsencryptCertificate

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.issue_letsencrypt_certificate(client, account_id = "1010", domain_id = "example.com", purchase_id = 100)

  """
  @spec issue_letsencrypt_certificate(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def issue_letsencrypt_certificate(client, account_id, domain_id, certificate_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/issue")

    Client.post(client, url, Client.empty_body(), options)
    |> Response.parse(%{"data" => %Certificate{}})
  end


  @doc """
  Purchase a Let's Encrypt certificate renewal.

  This method creates a new renewal order. The order ID should be used to
  request the issuance of the certificate using `#issue_letsencrypt_certificate_renewal`.

  See:
  - https://developer.dnsimple.com/v2/certificates/#purchaseRenewalLetsencryptCertificate

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate_renewal(client, account_id = "1010", domain_id = "example.com", certificate_id = 100)
      renewal_id      = response.data.id

      # Enable auto-renew on purchase
      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate_renewal(client, account_id = "1010", domain_id = "example.com", certificate_id = 100, auto_renew: true)

      # Signature Algorithm
      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.purchase_letsencrypt_certificate_renewal(client, account_id = "1010", domain_id = "example.com", certificate_id = 100, signature_algorithm: "RSA")

  """
  @spec purchase_letsencrypt_certificate_renewal(Client.t, String.t | integer, String.t | integer, integer, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def purchase_letsencrypt_certificate_renewal(client, account_id, domain_id, certificate_id, attributes \\ %{}, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %CertificateRenewal{}})
  end


  @doc """
  Issue a pending Let's Encrypt certificate renewal order.

  Note that the issuance process is async. A successful response means the issuance
  request has been successfully acknowledged and queued for processing.

  See:
  - https://developer.dnsimple.com/v2/certificates/#issueRenewalLetsencryptCertificate

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Certificates.issue_letsencrypt_certificate(client, account_id = "1010", domain_id = "example.com", certificate_id = 100, renewal_id: 200)

  """
  @spec issue_letsencrypt_certificate_renewal(Client.t, String.t | integer, String.t | integer, integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def issue_letsencrypt_certificate_renewal(client, account_id, domain_id, certificate_id, certificate_renewal_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/certificates/letsencrypt/#{certificate_id}/renewals/#{certificate_renewal_id}/issue")

    Client.post(client, url, Client.empty_body(), options)
    |> Response.parse(%{"data" => %Certificate{}})
  end
end
