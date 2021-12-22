defmodule Dnsimple.WhoisPrivacy do
  @moduledoc """
  Represents the whois privacy of a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    enabled: boolean,
    expires_on: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id enabled expires_on created_at updated_at)a

end
