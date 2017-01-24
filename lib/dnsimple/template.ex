defmodule Dnsimple.Template do
  @moduledoc """
  Represents a template.

  See:
  - https://developer.dnsimple.com/v2/templates/
  """

  @type t :: %__MODULE__{
    id: integer,
    sid: String.t,
    account_id: integer,
    name: String.t,
    description: String.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id sid account_id name description
               created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.Template do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.Template.t, Keyword.t) :: Dnsimple.Template.t
  def decode(entity, _), do: entity
end
