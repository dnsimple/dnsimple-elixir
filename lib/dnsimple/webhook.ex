defmodule Dnsimple.Webhook do
  @moduledoc """
  Represents a DNSimple webhook

  See:
  - https://developer.dnsimple.com/v2/webhooks
  """

  @type t :: %__MODULE__{
    id: integer,
    url: String.t,
  }

  defstruct ~w(id url)a

end
