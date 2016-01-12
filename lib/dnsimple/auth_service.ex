defmodule Dnsimple.AuthService do
  @moduledoc false

  def whoami(client) do
    response = Dnsimple.Client.get(client, Dnsimple.Client.versioned("whoami"))
    response.body
    |> Poison.decode!
    |> Map.get("data")
  end

end
