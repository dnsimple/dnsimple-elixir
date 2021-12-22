defmodule Dnsimple.User do
  @moduledoc """
  Represents a user.

  See:
  - https://developer.dnsimple.com/v2/identity/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    email: String.t,
  }

  defstruct ~w(id email)a

end
