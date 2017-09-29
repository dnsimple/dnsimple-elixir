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
    regions: list,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id zone_id parent_id type name content ttl priority
               system_record regions created_at updated_at)a

end
