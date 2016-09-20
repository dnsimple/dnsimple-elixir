defmodule Dnsimple.Identity do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Whoami
  alias Dnsimple.Account
  alias Dnsimple.User

  @doc """
  Returns information about the currently authenticated user and/or account.

  See: https://developer.dnsimple.com/v2/identity/#whoami

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Identity.whoami(client)

  """
  @spec whoami(Client.t, Keyword.t) :: Response.t
  def whoami(client, options \\ []) do
    url = Client.versioned("/whoami")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Whoami{account: %Account{}, user: %User{}}})
  end

end
