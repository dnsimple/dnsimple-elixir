defmodule Dnsimple.Account do
  @moduledoc """
  Represents an account.

  See:
  - https://developer.dnsimple.com/v2/accounts/
  """

  @type t :: %__MODULE__{
    id: integer,
    email: String.t,
    plan_identifier: String.t,
  }

  defstruct ~w(id email plan_identifier)a

end
