defmodule Dnsimple.EmailForward do
  @moduledoc """
  Represents an email forward.

  See: https://developer.dnsimple.com/v2/domains/email-forwards/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    from: String.t,
    to: String.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id domain_id from to created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.EmailForward do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.EmailForward.t, Keyword.t) :: Dnsimple.EmailForward.t
  def decode(entity, _), do: entity
end
