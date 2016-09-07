defmodule Dnsimple.Tlds do
  @moduledoc """
  This module provides functions to interact with the TLD related endpoints.

  See: https://developer.dnsimple.com/v2/tlds/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Tld

  @doc """
  Lists the supported TLDs on DNSimple.

  See https://developer.dnsimple.com/v2/tlds/#list
  """
  @spec list_tlds(Client.t, Keyword.t) :: Response.t
  def list_tlds(client, options \\ []) do
    url = Client.versioned("/tlds")

    List.get(client, url, options)
    |> Response.parse(Tld)
  end

  @spec tlds(Client.t, Keyword.t) :: Response.t
  defdelegate tlds(client, options \\ []), to: __MODULE__, as: :list_tlds

end
