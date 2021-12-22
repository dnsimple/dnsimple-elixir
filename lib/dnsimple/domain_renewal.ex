defmodule Dnsimple.DomainRenewal do
  @moduledoc """
  Represents a domain renewal.

  See:
  - https://developer.dnsimple.com/v2/registrar/#renew
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    period: integer,
    state: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id period state
               created_at updated_at)a

end
