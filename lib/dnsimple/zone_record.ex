defmodule Dnsimple.ZoneRecord do
  @fields [
    :id, :zone_id, :parent_id,
    :type, :name, :content, :ttl, :priority,
    :system_record, :created_at, :updated_at,
  ]

  @type t :: %__MODULE__{
    id: Integer.t, zone_id: Integer.t, parent_id: Integer.t,
    type: String.t, name: String.t, content: String.t, ttl: Integer.t, priority: Integer.t,
    system_record: Boolean.t, created_at: String.t, updated_at: String.t,
  }

  defstruct @fields
end
