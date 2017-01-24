defmodule Dnsimple.Zone do
  @moduledoc """
  Represents a zone.

  See:
  - https://developer.dnsimple.com/v2/zones/
  """

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    name: String.t,
    reverse: boolean,
    created_at: DateTime.t,
    updated_at: DateTime.t
  }

  defstruct ~w(id account_id name reverse created_at updated_at)a

  defmodule File do
    @moduledoc """
    Represents a zone file.

    See:
    - https://developer.dnsimple.com/v2/zones/#file
    - https://support.dnsimple.com/articles/zone-files/#whats-a-zone-file
    """

    @type t :: %__MODULE__{
      zone: String.t,
    }

    defstruct ~w(zone)a

  end
end

defimpl Poison.Decoder, for: Dnsimple.Zone do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.Zone.t, Keyword.t) :: Dnsimple.Zone.t
  def decode(entity, _), do: entity
end
