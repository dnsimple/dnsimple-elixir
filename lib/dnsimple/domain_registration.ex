defmodule Dnsimple.DomainRegistration do
  @moduledoc """
  Represents a domain registration.

  See:
  - https://developer.dnsimple.com/v2/registrar/#register
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    registrant_id: integer,
    period: integer,
    state: String.t,
    auto_renew: boolean,
    whois_privacy: boolean,
    premium_price: String.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id domain_id registrant_id period state auto_renew whois_privacy
               premium_price expires_on created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.DomainRegistration do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.DomainRegistration.t, Keyword.t) :: Dnsimple.DomainRegistration.t
  def decode(entity, _), do: entity
end
