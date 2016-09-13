defmodule Dnsimple.Accounts do
  @moduledoc """
  Accounts handles communication with the account related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/accounts/
  """

  alias Dnsimple.Client
  alias Dnsimple.Account
  alias Dnsimple.Response


  @doc """
  Lists the accounts

  See https://developer.dnsimple.com/v2/accounts/#list
  """
  @spec list_accounts(Client.t) :: Response.t
  def list_accounts(client, options \\ []) do
    url = Client.versioned("/accounts")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => [%Account{}]})
  end

  @spec accounts(Client.t) :: Response.t
  defdelegate accounts(client), to: __MODULE__, as: :list_accounts

end
