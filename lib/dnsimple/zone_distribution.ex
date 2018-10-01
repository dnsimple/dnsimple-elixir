defmodule Dnsimple.ZoneDistribution do
  @moduledoc """
  Represents the distribution status of a zone.

  See:
  - https://developer.dnsimple.com/v2/zones
  - https://developer.dnsimple.com/v2/zones/#checkZoneDistribution
  """

  @type t :: %__MODULE__{
    distributed: boolean,
  }

  defstruct ~w(distributed)a

end
