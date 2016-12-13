defmodule Dnsimple.Collaborator do
  @moduledoc """
  Represents a collaborator in a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/collaborators
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    domain_name: String.t,
    user_id: integer,
    user_email: String.t,
    invitation: boolean,
    accepted_at: DateTime.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id domain_id domain_name user_id user_email invitation
               accepted_at created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.Collaborator do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.Collaborator.t, Keyword.t) :: Dnsimple.Collaborator.t
  def decode(%{accepted_at: accepted_at} = certificate, options) when is_binary(accepted_at) do
    {:ok, accepted_at, _} = Dnsimple.DateTimeShim.from_iso8601(accepted_at)
    decode(%{certificate | accepted_at: accepted_at}, options)
  end
  def decode(certificate, _options), do: certificate
end
