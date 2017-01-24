defmodule Dnsimple.VanityNameServer do
  @moduledoc """
  Represents a vanity name server.

  See:
  - https://developer.dnsimple.com/v2/vanity/
  """

  @type t :: %__MODULE__{
    id: integer,
    name: String.t,
    ipv4: String.t,
    ipv6: String.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id name ipv4 ipv6 created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.VanityNameServer do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.VanityNameServer.t, Keyword.t) :: Dnsimple.VanityNameServer.t
  def decode(entity, _), do: entity
end
