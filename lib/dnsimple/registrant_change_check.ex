defmodule Dnsimple.RegistrantChangeCheck do
  @moduledoc """
  Represents a registrant change check response.

  Developer preview: this API is currently in open beta and subject to change.
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    contact_id: integer,
    domain_id: integer,
    extended_attributes: [map()],
    registry_owner_change: boolean
  }

  defstruct ~w(contact_id domain_id extended_attributes registry_owner_change)a

end
