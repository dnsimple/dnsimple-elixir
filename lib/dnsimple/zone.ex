defmodule Dnsimple.Zone do
  @moduledoc """
  Represents a zone.

  See: https://developer.dnsimple.com/v2/zones/
  """

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    name: String.t,
    reverse: boolean,
    created_at: String.t,
    updated_at: String.t
  }

  defstruct ~w(id account_id name reverse created_at updated_at)a

  defmodule File do
    @moduledoc """
    Represents a zone file.

    See: https://developer.dnsimple.com/v2/zones/#file
    See: https://support.dnsimple.com/articles/zone-files/#whats-a-zone-file
    """

    @type t :: %__MODULE__{
      zone: String.t,
    }

    defstruct ~w(zone)a

  end
end
