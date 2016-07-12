defmodule Dnsimple.ZoneRecord do
  @fields [
    :id, :zone_id, :parent_id,
    :type, :name, :content, :ttl, :priority,
    :system_record, :created_at, :updated_at,
  ]

  @type t :: %__MODULE__{
    id: integer, zone_id: integer, parent_id: integer,
    type: String.t, name: String.t, content: String.t, ttl: integer, priority: integer,
    system_record: boolean, created_at: String.t, updated_at: String.t,
  }

  defstruct @fields
end
