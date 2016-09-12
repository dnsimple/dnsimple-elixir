defmodule Dnsimple.Template do
  @moduledoc """
  Represents a template.

  See: https://developer.dnsimple.com/v2/templates/
  """

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    name: String.t,
    short_name: String.t,
    description: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id account_id name short_name description created_at updated_at)a

end
