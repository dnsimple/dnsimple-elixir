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
    from: String.t,
    to: String.t,
    alias_email: String.t,
    destination_email: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id from to alias_email destination_email created_at updated_at)a

end
