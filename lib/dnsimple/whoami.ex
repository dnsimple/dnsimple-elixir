defmodule Dnsimple.Whoami do
  @moduledoc """
  Represents the credentials used to login to the API.

  See https://developer.dnsimple.com/v2/identity/
  """

  @type t :: %__MODULE__{
    user: Dnsimple.User.t,
    account: Dnsimple.Account.t
  }

  defstruct ~w(user account)a

end
