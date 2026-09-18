defmodule Dnsimple.DnsAnalyticsRow do
  @moduledoc """
  Represents a row of DNS Analytics data.

  The groupings of the query set the fields. The fields that are not in the groupings are `nil`.

  See:
  - https://developer.dnsimple.com/v2/dns-analytics/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
          zone_name: String.t() | nil,
          date: String.t() | nil,
          volume: integer | nil
        }

  defstruct ~w(zone_name date volume)a
end
