defmodule Dnsimple.Identity do
  @moduledoc """
  Provides functions to interact with the
  [identity endpoints](https://developer.dnsimple.com/v2/identity/).

  See:
  - https://developer.dnsimple.com/v2/identity/
  """
  @moduledoc section: :api

  alias Dnsimple.Account
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.User
  alias Dnsimple.Whoami

  @doc """
  Returns information about the currently authenticated user and/or account.

  See:
  - https://developer.dnsimple.com/v2/identity/#whoami

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Identity.whoami(client)

  """
  @spec whoami(Client.t(), Keyword.t()) :: {:ok | :error, Response.t()}
  def whoami(client, options \\ []) do
    url = Client.versioned("/whoami")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Whoami{account: %Account{}, user: %User{}}})
  end
end
