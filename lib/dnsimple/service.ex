defmodule Dnsimple.Service do
  @moduledoc """
  Represents a one-click service.

  See:
  - https://developer.dnsimple.com/v2/services
  """

  defmodule Setting do
    @moduledoc """
    Represents a one-click service setting.

    See:
    - https://developer.dnsimple.com/v2/services
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
    sid: String.t,
    name: String.t,
    description: String.t,
    setup_description: String.t,
    default_subdomain: String.t,
    requires_setup: boolean,
    settings: List.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id sid name description setup_description
               default_subdomain requires_setup settings
               created_at updated_at)a

end
