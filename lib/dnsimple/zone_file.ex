defmodule Dnsimple.ZoneFile do
  @moduledoc """
  Represents a zone file.

  See:
  - https://developer.dnsimple.com/v2/zones/#file
  - https://support.dnsimple.com/articles/zone-files/#whats-a-zone-file
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    zone: String.t,
  }

  defstruct ~w(zone)a

end
