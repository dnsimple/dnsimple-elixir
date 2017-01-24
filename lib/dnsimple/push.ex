defmodule Dnsimple.Push do
  @moduledoc """
  Represents a push of a domain from an account to another.

  See:
  - https://developer.dnsimple.com/v2/domains/pushes/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    contact_id: integer,
    account_id: integer,
    accepted_at: DateTime.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id domain_id contact_id account_id
               accepted_at created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.Push do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.Push.t, Keyword.t) :: Dnsimple.Push.t
  def decode(%{accepted_at: accepted_at} = push, options) when is_binary(accepted_at) do
    {:ok, accepted_at, _} = Dnsimple.DateTimeShim.from_iso8601(accepted_at)
    decode(%{push | accepted_at: accepted_at}, options)
  end
  def decode(push, _options), do: push
end
