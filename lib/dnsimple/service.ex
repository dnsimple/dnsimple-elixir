defmodule Dnsimple.Service do
  @moduledoc """
  Represents a one-click service.

  See https://developer.dnsimple.com/v2/services/#service-attributes.
  """

  @type t :: %__MODULE__{
    id: integer,
    name: String.t,
    short_name: String.t,
    description: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id name short_name description created_at updated_at)a

end
