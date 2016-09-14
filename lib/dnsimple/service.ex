defmodule Dnsimple.Service do
  @moduledoc """
  Represents a one-click service.

  See https://developer.dnsimple.com/v2/services
  """

  defmodule Setting do
    @moduledoc """
    Represents a one-click service setting.

    See https://developer.dnsimple.com/v2/services
    """

    @type t :: %__MODULE__{
      name: String.t,
      label: String.t,
      append: String.t,
      description: String.t,
      example: String.t,
      password: boolean,
    }

    defstruct ~w(name label append description example password)a
  end


  @type t :: %__MODULE__{
    id: integer,
    name: String.t,
    short_name: String.t,
    description: String.t,
    settings: List.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id name short_name description settings created_at updated_at)a

end
