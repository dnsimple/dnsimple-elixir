defmodule Dnsimple.Webhook do
  @moduledoc """
  Represents a [DNSimple webhook](https://developer.dnsimple.com/v2/webhooks)
  """

  @fields [
    :id, :url,
    :created_at, :updated_at
  ]

  @type t :: %__MODULE__{
    id: integer, url: String.t,
    created_at: String.t, updated_at: String.t
  }

  defstruct @fields
end
