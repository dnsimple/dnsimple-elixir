defmodule Dnsimple.Domain do
  @moduledoc """
  Represents a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/
  - https://developer.dnsimple.com/v2/domains/#domain-attributes
  """

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    registrant_id: integer,
    name: String.t,
    unicode_name: String.t,
    token: String.t,
    state: String.t,
    auto_renew: boolean,
    private_whois: boolean,
    expires_on: Date.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id account_id registrant_id name unicode_name token state
               auto_renew private_whois expires_on created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.Domain do
  use Dnsimple.Decoder.Timestamps
  use Dnsimple.Decoder.Expires

  @spec decode(Dnsimple.Domain.t, Keyword.t) :: Dnsimple.Domain.t
  def decode(entity, _), do: entity
end
