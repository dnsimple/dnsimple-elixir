defmodule Dnsimple.TransferLock do
  @moduledoc """
  Represents the transfer lock status for a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/transfer_lock/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    enabled: boolean(),
  }

  defstruct ~w(enabled)a

end
