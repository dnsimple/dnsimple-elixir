defmodule Dnsimple.Template do
  @moduledoc """
  Represents a template.

  See:
  - https://developer.dnsimple.com/v2/templates/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    sid: String.t,
    account_id: integer,
    name: String.t,
    description: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id sid account_id name description
               created_at updated_at)a

end
