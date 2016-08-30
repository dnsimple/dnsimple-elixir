defmodule Dnsimple.Identity do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Whoami

  @spec whoami(Client.t, Keyword.t) :: Response.t
  def whoami(client, options \\ []) do
    {headers, opts} = Client.headers(options)

    Client.get(client, Client.versioned("/whoami"), headers, opts)
    |> Response.parse(Whoami)
  end

end
