defmodule Dnsimple.Registrar do
  @moduledoc """
  Provides functions to interact with the
  [registrar endpoints](https://developer.dnsimple.com/v2/registrar/).

  See:
  - https://developer.dnsimple.com/v2/registrar/
  - https://developer.dnsimple.com/v2/registrar/auto-renewal/
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/
  - https://developer.dnsimple.com/v2/registrar/delegation/
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.DomainCheck
  alias Dnsimple.DomainPremiumPrice
  alias Dnsimple.DomainPrice
  alias Dnsimple.DomainRegistration
  alias Dnsimple.DomainRenewal
  alias Dnsimple.DomainTransfer
  alias Dnsimple.WhoisPrivacy
  alias Dnsimple.WhoisPrivacyRenewal
  alias Dnsimple.VanityNameServer

  @doc """
  Checks if a domain name is available to be registered and whether premium
  pricing applies to that domain name.

  See:
  - https://developer.dnsimple.com/v2/registrar/#check

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.check_domain(client, account_id = 1010, domain_id = "example.com")

  """
  @spec check_domain(Client.t, String.t, String.t, keyword()) :: {:ok|:error, Response.t}
  def check_domain(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/check")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainCheck{}})
  end


  @doc """
  Gets the premium price for a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/#getDomainPremiumPrice

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com")
      {:ok, response} = Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com", %{action: "registration"})
      {:ok, response} = Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com", %{action: "renewal"})
      {:ok, response} = Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com", %{action: "transfer"})

  """
  @spec get_domain_premium_price(Client.t, String.t, String.t, map(), keyword()) :: {:ok|:error, Response.t}
  @deprecated "Use get_domain_prices/4 instead"
  def get_domain_premium_price(client, account_id, domain_name, params \\ %{}, options \\ []) do
    url     = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/premium_price")
    options = Keyword.put(options, :action, Map.get(params, :action))

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainPremiumPrice{}})
  end

  @doc """
  Get prices for a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/#getDomainPrices

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.get_domain_prices(client, account_id = "1010", domain_id = "example.com")
  """
  @spec get_domain_prices(Client.t, String.t, String.t, keyword()) :: {:ok|:error, Response.t}
  def get_domain_prices(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/prices")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainPrice{}})
  end

  @doc """
  Registers a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/#registerDomain

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.register_domain(client, account_id = 1010, domain_id = "example.com", %{
        registrant_id: 1,
        privacy: true,
        auto_renew: false,
      })

  """
  @spec register_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def register_domain(client, account_id, domain_name, attributes \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/registrations")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DomainRegistration{}})
  end

  @doc """
  Retrieve the details of an existing domain registration.

  See:
  - https://developer.dnsimple.com/v2/registrar/#getDomainRegistration

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.get_domain_registration(client, account_id = 1010, domain_id = "example.com", registration_id = 1)

  """
  @spec get_domain_registration(Client.t, String.t | integer, String.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_domain_registration(client, account_id, domain_name, registration_id, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/registrations/#{registration_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainRegistration{}})
  end


  @doc """
  Renews a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/#renewDomain

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.renew_domain(client, account_id = 1010, domain_id = "example.com")
      {:ok, response} = Dnsimple.Registrar.renew_domain(client, account_id = 1010, domain_id = "example.com", %{period: 5})

  """
  @spec renew_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def renew_domain(client, account_id, domain_name, attributes \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/renewals")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DomainRenewal{}})
  end


  @doc """
  Starts the transfer of a domain to DNSimple.

  See:
  - https://developer.dnsimple.com/v2/registrar/#transferDomain

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.transfer_domain(client, account_id = 1010, domain_id = "example.com", %{
        registrant_id: 1,
        auth_code: "XXXXXXXXX",
        privacy: true,
        auto_renew: true,
      })

  """
  @spec transfer_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: {:ok|:error, Response.t}
  def transfer_domain(client, account_id, domain_name, attributes \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/transfers")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DomainTransfer{}})
  end

  @doc """
  Retrieves the details of an existing domain transfer.

  See:
  - https://developer.dnsimple.com/v2/registrar/#getDomainTransfer

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.get_domain_transfer(client, account_id = 1010, domain_name = "example.com", transfer_id = 42)

  """
  @spec get_domain_transfer(Client.t, String.t | integer, String.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_domain_transfer(client, account_id, domain_name, domain_transfer_id, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/transfers/#{domain_transfer_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainTransfer{}})
  end

  @doc """
  Cancels an in progress domain transfer.

  See:
  - https://developer.dnsimple.com/v2/registrar/#cancelDomainTransfer

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.cancel_domain_transfer(client, account_id = 1010, domain_name = "example.com", transfer_id = 42)

  """
  @spec cancel_domain_transfer(Client.t, String.t | integer, String.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def cancel_domain_transfer(client, account_id, domain_name, domain_transfer_id, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/transfers/#{domain_transfer_id}")

    Client.delete(client, url, options)
    |> Response.parse(%{"data" => %DomainTransfer{}})
  end


  @doc """
  Requests the transfer of a domain out of DNSimple.

  See:
  - https://developer.dnsimple.com/v2/registrar/#authorizeDomainTransferOut

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.transfer_domain_out(client, account_id = 1010, domain_id = "example.com")

  """
  @spec transfer_domain_out(Client.t, String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def transfer_domain_out(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/authorize_transfer_out")

    Client.post(client, url, Client.empty_body(), options)
    |> Response.parse(nil)
  end


  @doc """
  Enables auto-renewal for the domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/auto-renewal/#enableDomainAutoRenewal

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.enable_domain_auto_renewal(client, account_id = 1010, domain_id = "example.com")

  """
  @spec enable_domain_auto_renewal(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def enable_domain_auto_renewal(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")

    Client.put(client, url, Client.empty_body(), options)
    |> Response.parse(nil)
  end


  @doc """
  Disables auto-renewal for the domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/auto-renewal/#disableDomainAutoRenewal

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.disable_domain_auto_renewal(client, account_id = 1010, domain_id = "example.com")

  """
  @spec disable_domain_auto_renewal(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def disable_domain_auto_renewal(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Returns the whois privacy of the domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/#getWhoisPrivacy

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.get_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec get_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def get_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %WhoisPrivacy{}})
  end


  @doc """
  Enables whois privacy for the domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/#enableWhoisPrivacy

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.enable_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec enable_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def enable_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.put(client, url, Client.empty_body(), options)
    |> Response.parse(%{"data" => %WhoisPrivacy{}})
  end


  @doc """
  Disables whois privacy for the domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/#disableWhoisPrivacy

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.disable_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec disable_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def disable_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.delete(client, url, options)
    |> Response.parse(%{"data" => %WhoisPrivacy{}})
  end


  @doc """
  Renews whois privacy for the domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/#renewWhoisPrivacy

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.renew_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec renew_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def renew_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy/renewals")

    Client.post(client, url, options)
    |> Response.parse(%{"data" => %WhoisPrivacyRenewal{}})
  end


  @doc """
  Returns the name servers the domain is delegating to.

  See:
  - https://developer.dnsimple.com/v2/registrar/delegation/#getDomainDelegation

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.get_domain_delegation(client, account_id = 1010, domain_id = "example.com")

  """
  @spec get_domain_delegation(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def get_domain_delegation(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => []})
  end


  @doc """
  Changes the domain's name servers and returns them.

  See:
  - https://developer.dnsimple.com/v2/registrar/delegation/#changeDomainDelegation

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.change_domain_delegation(client, account_id = 1010, domain_id = "example.com", [
        "ns1.provider.com",
        "ns2.provider.com",
        "ns3.provider.com",
        "ns4.provider.com",
      ])

  """
  @spec change_domain_delegation(Client.t, integer | String.t, String.t, list(), keyword()) :: {:ok|:error, Response.t}
  def change_domain_delegation(client, account_id, domain_name, name_servers, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation")

    Client.put(client, url, name_servers, options)
    |> Response.parse(%{"data" => []})
  end


  @doc """
  Delegates the domain to vanity name servers.

  See:
  - https://developer.dnsimple.com/v2/registrar/delegation/#changeDomainDelegationToVanity

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.change_domain_delegation_to_vanity(client, account_id = 1010, domain_id = "example.com", [
        "ns1.example.com",
        "ns2.example.com",
        "ns3.example.com",
        "ns4.example.com",
      ])

  """
  @spec change_domain_delegation_to_vanity(Client.t, integer | String.t, String.t, list(), keyword()) :: {:ok|:error, Response.t}
  def change_domain_delegation_to_vanity(client, account_id, domain_name, name_servers, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity")

    Client.put(client, url, name_servers, options)
    |> Response.parse(%{"data" => [%VanityNameServer{}]})
  end


  @doc """
  Reverts all the operations performed to delegate to vanity name servers and
  delegates the domain back to DNSimple's name servers (if DNSimple is the
  registrar of the domain).

  See:
  - https://developer.dnsimple.com/v2/registrar/delegation/#changeDomainDelegationFromVanity

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Registrar.change_domain_delegation_from_vanity(client, account_id = 1010, domain_id = "example.com")

  """
  @spec change_domain_delegation_from_vanity(Client.t, integer | String.t, String.t, Keyword.t) :: {:ok|:error, Response.t}
  def change_domain_delegation_from_vanity(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
