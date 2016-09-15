defmodule Dnsimple.EmailForward do
  @moduledoc """
  Represents an email forward.

  See: https://developer.dnsimple.com/v2/domains/email-forwards/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    from: String.t,
    to: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id from to created_at updated_at)a

end
