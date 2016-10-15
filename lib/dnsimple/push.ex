defmodule Dnsimple.Push do
  @moduledoc """
  Represents a push of a domain from an account to another.

  See: https://developer.dnsimple.com/v2/pushes/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    contact_id: integer,
    account_id: integer,
    accepted_at: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id contact_id account_id
               accepted_at created_at updated_at)a

end
