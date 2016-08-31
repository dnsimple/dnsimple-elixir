defmodule Dnsimple.Accounts do
  @moduledoc """
  AccountsService handles communication with the account related
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
  @spec accounts(Client.t) :: Response.t
  def accounts(client, options \\ []) do
    url = Client.versioned("/accounts")

    Client.get(client, url, options)
    |> Response.parse(Account)
  end

end
