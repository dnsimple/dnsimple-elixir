defmodule Dnsimple.VanityNameServers do
  @moduledoc """
  This module provides functions to interact with the vanity name server
  related endpoints.

  See: https://developer.dnsimple.com/v2/vanity/
  """

  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.VanityNameServer

  @doc """
  Enables and returns vanity name servers for the domain.

  See https://developer.dnsimple.com/v2/vanity/#enable

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.VanityNameServers.enable_vanity_name_servers(client, account_id = 1010, domain_id = "example.com")

  """
  @spec enable_vanity_name_servers(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def enable_vanity_name_servers(client, account_id, domain_id, options \\ []) do
    url = Client.versioned("/#{account_id}/vanity/#{domain_id}")

    Client.put(client, url, Client.empty_body, options)
    |> Response.parse(%{"data" => [%VanityNameServer{}]})
  end

end
