defmodule Dnsimple.DomainRestore do
  @moduledoc """
  Represents a domain restore.

  See:
  - https://developer.dnsimple.com/v2/registrar/#restoreDomain
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
          id: integer,
          domain_id: integer,
          state: String.t(),
          created_at: String.t(),
          updated_at: String.t()
        }

  defstruct ~w(id domain_id state
               created_at updated_at)a
end
