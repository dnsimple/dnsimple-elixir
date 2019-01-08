defmodule Dnsimple.WhoisPrivacyRenewal do
  @moduledoc """
  Represents the whois privacy renewal of a domain.

  See:
  - https://developer.dnsimple.com/v2/registrar/whois-privacy/
  """

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    whois_privacy_id: integer,
    state: String.t,
    enabled: boolean,
    expires_on: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id whois_privacy_id state enabled expires_on created_at updated_at)a

end
