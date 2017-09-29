defmodule Dnsimple.VanityNameServers do
  @moduledoc """
  Provides functions to interact with the
  [vanity name server endpoints](https://developer.dnsimple.com/v2/vanity/).

  See:
  - https://developer.dnsimple.com/v2/vanity/
  """

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.VanityNameServer

  @doc """
  Enables vanity name servers for the domain.

  See:
  - https://developer.dnsimple.com/v2/vanity/#enable

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.VanityNameServers.enable_vanity_name_servers(client, account_id = 1010, domain_id = "example.com")

  """
  @spec enable_vanity_name_servers(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def enable_vanity_name_servers(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/vanity/#{domain_id}")

    Client.put(client, url, Client.empty_body(), options)
    |> Response.parse(%{"data" => [%VanityNameServer{}]})
  end


  @doc """
  Disables vanity name servers for the domain.

  See:
  - https://developer.dnsimple.com/v2/vanity/#disable

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.VanityNameServers.disable_vanity_name_servers(client, account_id = 1010, domain_id = "example.com")

  """
  @spec disable_vanity_name_servers(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def disable_vanity_name_servers(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/vanity/#{domain_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
