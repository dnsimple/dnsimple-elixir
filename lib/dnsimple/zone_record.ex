defmodule Dnsimple.ZoneRecord do
  @moduledoc """
  Represents a record of a zone.

  See:
  - https://developer.dnsimple.com/v2/zones/records
  - https://developer.dnsimple.com/v2/zones/records/#zone-record-regions
  """

  @type t :: %__MODULE__{
    id: integer,
    zone_id: integer,
    parent_id: integer,
    type: String.t,
    name: String.t,
    content: String.t,
    ttl: integer,
    priority: integer,
    system_record: boolean,
    regions: List.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id zone_id parent_id type name content ttl priority
               system_record regions created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.ZoneRecord do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.ZoneRecord.t, Keyword.t) :: Dnsimple.ZoneRecord.t
  def decode(entity, _), do: entity
end
