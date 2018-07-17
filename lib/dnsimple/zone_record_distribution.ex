defmodule Dnsimple.ZoneRecordDistribution do
  @moduledoc """
  Represents the distribution status of a zone record.

  See:
  - https://developer.dnsimple.com/v2/zones
  - https://developer.dnsimple.com/v2/zones/#checkZoneRecordDistribution
  """

  @type t :: %__MODULE__{
    distributed: boolean,
  }

  defstruct ~w(distributed)a

end
