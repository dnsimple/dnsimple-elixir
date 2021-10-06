defmodule Dnsimple.Tld do
  @moduledoc """
  Represents a TLD.

  See: https://developer.dnsimple.com/v2/tlds
  See: https://developer.dnsimple.com/v2/tlds/#tld-attributes
  """

  @type t :: %__MODULE__{
    tld: String.t,
    tld_type: integer,
    idn: boolean,
    whois_privacy: boolean,
    auto_renew_only: boolean,
    minimum_registration: integer,
    registration_enabled: boolean,
    renewal_enabled: boolean,
    transfer_enabled: boolean,
    dnssec_interface_type: String.t,
  }

  defstruct ~w(tld tld_type idn whois_privacy auto_renew_only
               minimum_registration registration_enabled
               renewal_enabled transfer_enabled dnssec_interface_type)a

end
