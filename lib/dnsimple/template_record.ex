defmodule Dnsimple.TemplateRecord do
  @moduledoc """
  Represents a template record.

  See: https://developer.dnsimple.com/v2/templates/records/
  """

  @type t :: %__MODULE__{
    id: integer,
    template_id: integer,
    type: String.t,
    name: String.t,
    content: String.t,
    ttl: integer,
    priority: integer,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id template_id type name content ttl priority
               created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.TemplateRecord do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.TemplateRecord.t, Keyword.t) :: Dnsimple.TemplateRecord.t
  def decode(entity, _), do: entity
end
