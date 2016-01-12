defmodule Dnsimple.Domain do
  defstruct [:id, :name]
  @type t :: %__MODULE__{id: integer, name: String.t}
end
