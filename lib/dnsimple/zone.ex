defmodule Dnsimple.Zone do
  defstruct [
    :id, :account_id, :name,
    :reverse, :created_at, :updated_at
  ]
  @type t :: %__MODULE__{
    id: integer, account_id: integer, name: String.t,
    reverse: boolean, created_at: String.t, updated_at: String.t,
  }
end

