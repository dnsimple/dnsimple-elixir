defmodule Dnsimple.Webhook do
  @moduledoc """
  Represents a DNSimple webhook

  See:
  - https://developer.dnsimple.com/v2/webhooks
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    url: String.t,
  }

  defstruct ~w(id url)a

end
