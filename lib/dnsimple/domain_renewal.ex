defmodule Dnsimple.DomainRenewal do
  @moduledoc """
  Represents a domain renewal.

  See:
  - https://developer.dnsimple.com/v2/registrar/#renew
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    period: integer,
    state: String.t,
    premium_price: String.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id domain_id period state premium_price
               created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.DomainRenewal do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.DomainRenewal.t, Keyword.t) :: Dnsimple.DomainRenewal.t
  def decode(entity, _), do: entity
end
