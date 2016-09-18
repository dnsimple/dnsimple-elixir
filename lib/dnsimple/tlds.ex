defmodule Dnsimple.Tlds do
  @moduledoc """
  This module provides functions to interact with the TLD related endpoints.

  See: https://developer.dnsimple.com/v2/tlds/
  """

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Tld
  alias Dnsimple.TldExtendedAttribute

  @doc """
  Returns the lists of supported TLDs on DNSimple.

  See https://developer.dnsimple.com/v2/tlds/#list

  ## Examples

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Tlds.list_tlds(client)
    Dnsimple.Tlds.list_tlds(client, page: 2, per_page: 10)
    Dnsimple.Tlds.list_tlds(client, sort: "tlds:desc")

  """
  @spec list_tlds(Client.t, Keyword.t) :: Response.t
  def list_tlds(client, options \\ []) do
    url = Client.versioned("/tlds")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Tld{}], "pagination" => %Response.Pagination{}})
  end

  @spec tlds(Client.t, Keyword.t) :: Response.t
  defdelegate tlds(client, options \\ []), to: __MODULE__, as: :list_tlds


  @doc """
  Returns the information about a TLD.

  See https://developer.dnsimple.com/v2/tlds/#get

  ## Examples

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Tlds.get_tld(client, "com")

  """
  @spec get_tld(Client.t, String.t,  Keyword.t) :: Response.t
  def get_tld(client, tld, options \\ []) do
    url = Client.versioned("/tlds/#{tld}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Tld{}})
  end

  @spec tld(Client.t, String.t, Keyword.t) :: Response.t
  defdelegate tld(client, tld, options \\ []), to: __MODULE__, as: :get_tld


  @doc """
  Returns the extended attributes required for a particular TLD.

  See https://developer.dnsimple.com/v2/tlds/#extended-attributes

  ## Examples
  #
    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Tlds.get_tld_extended_attributes(client, "com")

  """
  @spec get_tld_extended_attributes(Client.t, String.t,  Keyword.t) :: Response.t
  def get_tld_extended_attributes(client, tld, options \\ []) do
    url = Client.versioned("/tlds/#{tld}/extended_attributes")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => [%TldExtendedAttribute{options: [%TldExtendedAttribute.Option{}]}]})
  end

  @spec tld_extended_attributes(Client.t, String.t,  Keyword.t) :: Response.t
  defdelegate tld_extended_attributes(client, tld, options \\ []), to: __MODULE__, as: :get_tld_extended_attributes

end
