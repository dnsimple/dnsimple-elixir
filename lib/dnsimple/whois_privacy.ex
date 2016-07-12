defmodule Dnsimple.WhoisPrivacy do
  defstruct [:id, :domain_id, :enabled, :expires_on, :created_at, :updated_at]
  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    enabled: boolean,
    expires_on: String.t,
    created_at: String.t,
    updated_at: String.t,
  }
end
