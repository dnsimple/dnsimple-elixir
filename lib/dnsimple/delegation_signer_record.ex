defmodule Dnsimple.DelegationSignerRecord do
  @moduledoc """
  Represents a delegation signer record.

  See:
  - https://developer.dnsimple.com/v2/domains/dnssec/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    algorithm: String.t,
    digest: String.t,
    digest_type: String.t,
    keytag: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id algorithm digest digest_type keytag created_at updated_at)a

end
