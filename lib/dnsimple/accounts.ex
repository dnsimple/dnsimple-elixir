defmodule Dnsimple.Accounts do
  @moduledoc """
  Provides functions to interact with the
  [account endpoints](https://developer.dnsimple.com/v2/accounts/).
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Account
  alias Dnsimple.Response


  @doc """
  Lists the accounts the current authenticated entity has access to.

  See:
  - https://developer.dnsimple.com/v2/accounts/#list

  Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Accounts.list_accounts(client)

  """
  @spec list_accounts(Client.t) :: {:ok|:error, Response.t}
  def list_accounts(client, options \\ []) do
    url = Client.versioned("/accounts")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => [%Account{}]})
  end

end
