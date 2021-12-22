defmodule Dnsimple.Dnssec do
  @moduledoc """
  Represents the current state of DNSSEC for the domain.

  See:
  - https://developer.dnsimple.com/v2/domains/dnssec/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    enabled: boolean(),
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id enabled created_at updated_at)a

end
