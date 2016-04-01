defmodule Dnsimple.RegistrarService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.DomainCheck

  @spec check_domain(Client.t, String.t, Keyword.t) :: Response.t
  def check_domain(client, domain_name, options \\ []) do
    Client.get(client, Client.versioned("/registrar/domains/#{domain_name}/check"), options)
      |> Response.parse(DomainCheck)
  end

end
