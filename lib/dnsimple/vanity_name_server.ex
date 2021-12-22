defmodule Dnsimple.VanityNameServer do
  @moduledoc """
  Represents a vanity name server.

  See:
  - https://developer.dnsimple.com/v2/vanity/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    name: String.t,
    ipv4: String.t,
    ipv6: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id name ipv4 ipv6 created_at updated_at)a

end
