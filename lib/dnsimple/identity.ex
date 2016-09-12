defmodule Dnsimple.Identity do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Whoami

  @doc """
  Returns information about the currently authenticated user and/or account.

  See: https://developer.dnsimple.com/v2/identity/#whoami
  """
  @spec whoami(Client.t, Keyword.t) :: Response.t
  def whoami(client, options \\ []) do
    url = Client.versioned("/whoami")

    Client.get(client, url, options)
    |> Response.parse(Whoami)
  end

end
