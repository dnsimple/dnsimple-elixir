defmodule Dnsimple.Whoami do
  defstruct [:user, :account]
  @type t :: %__MODULE__{user: Dnsimple.User.t, account: Dnsimple.Account.t}
end
