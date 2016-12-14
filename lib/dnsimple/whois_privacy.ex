defmodule Dnsimple.WhoisPrivacy do
  @moduledoc """
  Represents the whois privacy service of a domain.

  See https://developer.dnsimple.com/v2/registrar/whois-privacy/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    enabled: boolean,
    expires_on: Date.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id domain_id enabled expires_on created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.WhoisPrivacy do
  use Dnsimple.Decoder.Timestamps
  use Dnsimple.Decoder.Expires

  @spec decode(Dnsimple.WhoisPrivacy.t, Keyword.t) :: Dnsimple.WhoisPrivacy.t
  def decode(entity, _), do: entity
end
