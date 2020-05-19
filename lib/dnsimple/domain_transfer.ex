defmodule Dnsimple.DomainTransfer do
  @moduledoc """
  Represents a domain transfer.

  See:
  - https://developer.dnsimple.com/v2/registrar/#transfer
  """
  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    registrant_id: integer,
    state: String.t,
    auto_renew: boolean,
    whois_privacy: boolean,
    status_description: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id registrant_id
               state auto_renew whois_privacy status_description
               created_at updated_at)a

end
