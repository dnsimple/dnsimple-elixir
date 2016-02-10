defmodule Dnsimple.Record do
  defstruct [
    :id, :zone_id, :parent_id, :name,
    :content, :ttl, :priority, :type,
    :system_record, :created_at, :updated_at
  ]
  @type t :: %__MODULE__{
    id: integer, zone_id: String.t, parent_id: integer, name: String.t,
    content: String.t, ttl: integer, priority: integer, type: String.t,
    system_record: boolean, created_at: String.t, updated_at: String.t
  }

  def to_json(record) do
    record
    |> Map.from_struct
    |> Dict.take([:name, :content, :ttl, :priority])
    |> Poison.encode!
  end

end

