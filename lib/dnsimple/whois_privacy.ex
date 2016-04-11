defmodule Dnsimple.WhoisPrivacy do
  defstruct [:id, :domain_id, :enabled, :expires_on, :created_at, :updated_at]
  @type t :: %__MODULE__{
    id: Integer.t,
    domain_id: Integer.t,
    enabled: Boolean.t,
    expires_on: String.t,
    created_at: String.t,
    updated_at: String.t,
  }
end
