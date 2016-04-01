defmodule Dnsimple.RegistrarService do
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Domain
  alias Dnsimple.DomainCheck

  @spec check_domain(Client.t, String.t, Keyword.t) :: Response.t
  def check_domain(client, domain_name, options \\ []) do
    Client.get(client, Client.versioned("/registrar/domains/#{domain_name}/check"), options)
      |> Response.parse(DomainCheck)
  end

  @spec register_domain(Client.t, String.t, String.t, Keyword.t, Keyword.t, Keyword.t) :: Response.t
  def register_domain(client, account_id, domain_name, attributes \\ [], headers \\ [], options \\ []) do
    url = Client.versioned("/a/#{account_id}/registrar/domains/#{domain_name}/registration")

    Client.post(client, url, attributes, headers, options)
      |> Response.parse(Domain)
  end

end
