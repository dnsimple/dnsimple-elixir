defmodule Dnsimple.Tlds do
  @moduledoc """
  Provides functions to interact with the
  [TLD endpoints](https://developer.dnsimple.com/v2/tlds/).

  See:
  - https://developer.dnsimple.com/v2/tlds/
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Tld
  alias Dnsimple.TldExtendedAttribute

  @doc """
  Returns the lists of DNSimple supported TLDs.

  See:
  - https://developer.dnsimple.com/v2/tlds/#listTlds

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Tlds.list_tlds(client)
      {:ok, response} = Dnsimple.Tlds.list_tlds(client, page: 2, per_page: 10)
      {:ok, response} = Dnsimple.Tlds.list_tlds(client, sort: "tlds:desc")

  """
  @spec list_tlds(Client.t, Keyword.t) :: {:ok|:error, Response.t}
  def list_tlds(client, options \\ []) do
    url = Client.versioned("/tlds")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Tld{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a TLD.

  See:
  - https://developer.dnsimple.com/v2/tlds/#getTld

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Tlds.get_tld(client, "com")

  """
  @spec get_tld(Client.t, String.t,  Keyword.t) :: {:ok|:error, Response.t}
  def get_tld(client, tld, options \\ []) do
    url = Client.versioned("/tlds/#{tld}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Tld{}})
  end


  @doc """
  Returns the extended attributes for a TLD.

  See:
  - https://developer.dnsimple.com/v2/tlds/#getTldExtendedAttributes

  ## Examples

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Tlds.get_tld_extended_attributes(client, "com")

  """
  @spec get_tld_extended_attributes(Client.t, String.t,  Keyword.t) :: {:ok|:error, Response.t}
  def get_tld_extended_attributes(client, tld, options \\ []) do
    url = Client.versioned("/tlds/#{tld}/extended_attributes")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => [%TldExtendedAttribute{options: [%TldExtendedAttribute.Option{}]}]})
  end

end
