defmodule Dnsimple.Registrar do
  @moduledoc """
  This module provides functions to interact with the registrar related endpoints.

  See: https://developer.dnsimple.com/v2/registrar/
  See: https://developer.dnsimple.com/v2/registrar/auto-renewal/
  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/
  See: https://developer.dnsimple.com/v2/registrar/delegation/
  """

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.DomainCheck
  alias Dnsimple.DomainPremiumPrice
  alias Dnsimple.DomainRegistration
  alias Dnsimple.DomainRenewal
  alias Dnsimple.DomainTransfer
  alias Dnsimple.WhoisPrivacy
  alias Dnsimple.VanityNameServer

  @doc """
  Checks whether a domain is available to be registered.

  See: https://developer.dnsimple.com/v2/registrar/#check

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.check_domain(client, account_id = 1010, domain_id = "example.com")

  """
  @spec check_domain(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def check_domain(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/check")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainCheck{}})
  end


  @doc """
  Checks the premium price for a domain.

  See: https://developer.dnsimple.com/v2/registrar/#premium-price

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com")
    Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com", %{action: "registration"})
    Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com", %{action: "renewal"})
    Dnsimple.Registrar.get_domain_premium_price(client, account_id = "1010", domain_id = "example.com", %{action: "transfer"})

  """
  @spec get_domain_premium_price(Client.t, String.t, String.t, Map.t, Keyword.t) :: Response.t
  def get_domain_premium_price(client, account_id, domain_name, params \\ %{}, options \\ []) do
    url     = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/premium_price")
    options = Keyword.put(options, :action, Map.get(params, :action))

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %DomainPremiumPrice{}})
  end


  @doc """
  Registers a domain.

  See https://developer.dnsimple.com/v2/registrar/#register

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.register_domain(client, account_id = 1010, domain_id = "example.com", %{
      registrant_id: 1,
      privacy: true,
      auto_renew: false,
    })

  """
  @spec register_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def register_domain(client, account_id, domain_name, attributes \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/registration")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DomainRegistration{}})
  end


  @doc """
  Renews a domain.

  See https://developer.dnsimple.com/v2/registrar/#renew

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.renew_domain(client, account_id = 1010, domain_id = "example.com")
    Dnsimple.Registrar.renew_domain(client, account_id = 1010, domain_id = "example.com", %{period: 5})

  """
  @spec renew_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def renew_domain(client, account_id, domain_name, attributes \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/renewal")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DomainRenewal{}})
  end


  @doc """
  Starts the transfer of a domain to DNSimple.

  See https://developer.dnsimple.com/v2/registrar/#transfer

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.transfer_domain(client, account_id = 1010, domain_id = "example.com", %{
      registrant_id: 1,
      auth_code: "XXXXXXXXX",
      privacy: true,
      auto_renew: true,
    })

  """
  @spec transfer_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t) :: Response.t
  def transfer_domain(client, account_id, domain_name, attributes \\ [], options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/transfer")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %DomainTransfer{}})
  end


  @doc """
  Requests the transfer of a domain out of DNSimple.

  See https://developer.dnsimple.com/v2/registrar/#transfer_out

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.transfer_domain_out(client, account_id = 1010, domain_id = "example.com")

  """
  @spec transfer_domain_out(Client.t, String.t, String.t, Keyword.t) :: Response.t
  def transfer_domain_out(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/transfer_out")

    Client.post(client, url, Client.empty_body, options)
    |> Response.parse(nil)
  end


  @doc """
  Enables auto-renewal for the domain.

  See: https://developer.dnsimple.com/v2/registrar/auto-renewal/#enable

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.enable_domain_auto_renewal(client, account_id = 1010, domain_id = "example.com")

  """
  @spec enable_domain_auto_renewal(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def enable_domain_auto_renewal(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")

    Client.put(client, url, Client.empty_body, options)
    |> Response.parse(nil)
  end


  @doc """
  Disables auto-renewal for the domain.

  See: https://developer.dnsimple.com/v2/registrar/auto-renewal/#disable

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.disable_domain_auto_renewal(client, account_id = 1010, domain_id = "example.com")

  """
  @spec disable_domain_auto_renewal(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def disable_domain_auto_renewal(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/auto_renewal")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Returns the whois privacy of the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#get

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.get_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec get_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def get_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %WhoisPrivacy{}})
  end

  @spec whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  defdelegate whois_privacy(client, account_id, domain_name, options \\ []), to: __MODULE__, as: :get_whois_privacy


  @doc """
  Enables whois privacy for the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#enable

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.enable_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec enable_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def enable_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.put(client, url, Client.empty_body, options)
    |> Response.parse(%{"data" => %WhoisPrivacy{}})
  end


  @doc """
  Disables whois privacy for the domain.

  See: https://developer.dnsimple.com/v2/registrar/whois-privacy/#disable

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.disable_whois_privacy(client, account_id = 1010, domain_id = "example.com")

  """
  @spec disable_whois_privacy(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def disable_whois_privacy(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/whois_privacy")

    Client.delete(client, url, options)
    |> Response.parse(%{"data" => %WhoisPrivacy{}})
  end


  @doc """
  Returns the name servers the domain is delegating to.

  See: https://developer.dnsimple.com/v2/registrar/delegation/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.get_domain_delegation(client, account_id = 1010, domain_id = "example.com")

  """
  @spec get_domain_delegation(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def get_domain_delegation(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => []})
  end

  @spec domain_delegation(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  defdelegate domain_delegation(client, account_id, domain_name, options \\ []), to: __MODULE__, as: :get_domain_delegation

  @doc """
  Changes the domain's name servers and returns them.

  See: https://developer.dnsimple.com/v2/registrar/delegation/#update

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.change_domain_delegation(client, account_id = 1010, domain_id = "example.com", [
      "ns1.provider.com",
      "ns2.provider.com",
      "ns3.provider.com",
      "ns4.provider.com",
    ])

  """
  @spec change_domain_delegation(Client.t, integer | String.t, String.t, List.t, Keyword.t) :: Response.t
  def change_domain_delegation(client, account_id, domain_name, name_servers, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation")

    Client.put(client, url, name_servers, options)
    |> Response.parse(%{"data" => []})
  end


  @doc """
  Changes the domain's name servers to a set of vanity name servers and
  returns them.

  See: https://developer.dnsimple.com/v2/registrar/delegation/#delegateToVanity

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.change_domain_delegation_to_vanity(client, account_id = 1010, domain_id = "example.com", [
      "ns1.example.com.com",
      "ns2.example.com.com",
      "ns3.example.com.com",
      "ns4.example.com.com",
    ])

  """
  @spec change_domain_delegation_to_vanity(Client.t, integer | String.t, String.t, List.t, Keyword.t) :: Response.t
  def change_domain_delegation_to_vanity(client, account_id, domain_name, name_servers, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity")

    Client.put(client, url, name_servers, options)
    |> Response.parse(%{"data" => [%VanityNameServer{}]})
  end


  @doc """
  Reverts all the operations performed to delegate to vanity name servers and
  delegates the domain back to DNSimple's name servers (if DNSimple is the
  registrar of the domain).

  See: https://developer.dnsimple.com/v2/registrar/delegation/#dedelegateFromVanity

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Registrar.change_domain_delegation_from_vanity(client, account_id = 1010, domain_id = "example.com")

  """
  @spec change_domain_delegation_from_vanity(Client.t, integer | String.t, String.t, Keyword.t) :: Response.t
  def change_domain_delegation_from_vanity(client, account_id, domain_name, options \\ []) do
    url = Client.versioned("/#{account_id}/registrar/domains/#{domain_name}/delegation/vanity")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
