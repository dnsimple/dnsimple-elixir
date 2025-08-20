defmodule Dnsimple.EmailForward do
  @moduledoc """
  Represents an email forward.

  See:
  - https://developer.dnsimple.com/v2/domains/email-forwards/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    alias_email: String.t,
    destination_email: String.t,
    active: boolean,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id from to alias_email destination_email active created_at updated_at)a

end
