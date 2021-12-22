defmodule Dnsimple.Collaborator do
  @moduledoc """
  Represents a collaborator in a domain.

  See:
  - https://developer.dnsimple.com/v2/domains/collaborators
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    domain_name: String.t,
    user_id: integer,
    user_email: String.t,
    invitation: boolean,
    accepted_at: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id domain_name user_id user_email invitation
               accepted_at created_at updated_at)a

end
