defmodule Dnsimple.IdentityService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Whoami

  @spec whoami(Client.t, Keyword.t) :: Response.t
  def whoami(client, options \\ []) do
    response = Client.get(client, Client.versioned("/whoami"), options)

    Response.new(response, Response.data(response, Whoami))
  end

end
