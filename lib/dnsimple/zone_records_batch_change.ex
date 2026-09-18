defmodule Dnsimple.ZoneRecordsBatchChange do
  @moduledoc """
  Represents the result of a batch change of the records in a zone.

  See:
  - https://developer.dnsimple.com/v2/zones/records/#batchChangeZoneRecords
  """
  @moduledoc section: :data_types

  defmodule Delete do
    @moduledoc """
    Represents a zone record that a batch change deletes.

    See:
    - https://developer.dnsimple.com/v2/zones/records/#batchChangeZoneRecords
    """
    @moduledoc section: :data_types

    @type t :: %__MODULE__{
            id: integer
          }

    defstruct ~w(id)a
  end

  @type t :: %__MODULE__{
          creates: [Dnsimple.ZoneRecord.t()],
          updates: [Dnsimple.ZoneRecord.t()],
          deletes: [Delete.t()]
        }

  defstruct ~w(creates updates deletes)a
end
