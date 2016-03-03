defmodule Dnsimple.IdentityService do
  alias Dnsimple.Client

  @spec whoami(Client.t, Keyword.t) :: map
  def whoami(client, options \\ []) do
    response = Client.get(client, Client.versioned("/whoami"), options)
    response.body
    |> Poison.decode!
    |> Map.get("data")
  end

end
