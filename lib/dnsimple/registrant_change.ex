defmodule Dnsimple.RegistrantChange do
  @moduledoc """
  Represents a registrant change.

  Developer preview: this API is currently in open beta and subject to change.
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    contact_id: integer,
    domain_id: integer,
    state: String.t,
    extended_attributes: map(),
    registry_owner_change: boolean,
    irt_lock_lifted_by: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id account_id contact_id domain_id state extended_attributes
               registry_owner_change irt_lock_lifted_by created_at updated_at)a

end
