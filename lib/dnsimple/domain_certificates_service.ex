defmodule Dnsimple.DomainCertificatesService do
  @moduledoc """
  DomainCertificatesService handles communication with the DNSimple
  API responsible for providing certificates attached to domains.

  @see https://developer.dnsimple.com/v2/domains/certificates/
  """

  alias Dnsimple.Client
  alias Dnsimple.ListOptions
  alias Dnsimple.Response
  alias Dnsimple.Certificate

  @doc """
  List certificates.

  See https://developer.dnsimple.com/v2/domains/certificates/#list
  """
  @spec certificates(Client.t, String.t | integer, String.t | integer) :: Response.t
  def certificates(client, account_id, domain_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/domains/#{domain_id}/certificates"), headers, ListOptions.prepare(opts))
    |> Response.parse(Certificate)
  end
end
