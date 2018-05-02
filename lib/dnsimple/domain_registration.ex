defmodule Dnsimple.DomainRegistration do
  @moduledoc """
  Represents a domain registration.

  See:
  - https://developer.dnsimple.com/v2/registrar/#register
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    registrant_id: integer,
    period: integer,
    state: String.t,
    auto_renew: boolean,
    whois_privacy: boolean,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id registrant_id
               period state auto_renew whois_privacy
               expires_on created_at updated_at)a

end
