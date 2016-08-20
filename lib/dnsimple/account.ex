defmodule Dnsimple.Account do
  defstruct [:id, :email, :plan_identifier]
  @type t :: %__MODULE__{id: integer, email: String.t, plan_identifier: String.t}
end
