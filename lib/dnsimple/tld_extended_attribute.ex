defmodule Dnsimple.TldExtendedAttribute do
  @moduledoc """
  Represents an extended attribute of a TLD.

  See: https://developer.dnsimple.com/v2/tlds/#extended-attributes
  """

  defmodule Option do
    @moduledoc """
    Represents one of the accepted values for an extended attribute of a TLD.

    See: https://developer.dnsimple.com/v2/tlds/#extended-attributes
    """

    @type t :: %__MODULE__{
      title: String.t,
      value: String.t,
      description: String.t,
    }

    defstruct ~w(title value description)a
  end


  @type t :: %__MODULE__{
    name: String.t,
    description: String.t,
    required: boolean,
    options: [Option.t],
  }

  defstruct ~w(name description required options)a

end
