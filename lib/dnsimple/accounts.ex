defmodule Dnsimple.Accounts do
  @moduledoc """
  AccountsService handles communication with the account related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/accounts/
  """

  alias Dnsimple.Client
  alias Dnsimple.Account
  alias Dnsimple.Response
  alias Dnsimple.ListOptions


  @doc """
  Lists the accounts

  See https://developer.dnsimple.com/v2/accounts/#list
  """
  @spec accounts(Client.t) :: Response.t
  def accounts(client, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/accounts"), headers, ListOptions.prepare(opts))
    |> Response.parse(Account)
  end

end
