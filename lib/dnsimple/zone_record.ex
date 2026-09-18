defmodule Dnsimple.ZoneRecord do
  @moduledoc """
  Represents a record of a zone.

  See:
  - https://developer.dnsimple.com/v2/zones/records
  - https://developer.dnsimple.com/v2/zones/records/#ZoneRecordRegions

  The `parent_id` field is deprecated. Its value is always `nil`, and the field will be removed in the next major version.
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
          id: integer,
          zone_id: integer,
          parent_id: integer,
          type: String.t(),
          name: String.t(),
          content: String.t(),
          ttl: integer,
          priority: integer,
          system_record: boolean,
          regions: list,
          created_at: String.t(),
          updated_at: String.t()
        }

  defstruct ~w(id zone_id parent_id type name content ttl priority
               system_record regions created_at updated_at)a
end
