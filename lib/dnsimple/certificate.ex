defmodule Dnsimple.Certificate do
  @moduledoc """
  Represents an SSL certificate.

  The `server`, `root` and `chain` attributes are only relevant for the
  download endpoint accessible through `Dnsimple.Certificates.download_certificate/5`.

  The `private_key` attribute is only relevant for the private key endpoint
  accessible through `Dnsimple.Certificates.get_certificate_private_key/5`.

  See:
  - https://developer.dnsimple.com/v2/certificates
  - https://developer.dnsimple.com/v2/certificates/#certificate-attributes
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    contact_id: integer,
    common_name: String.t,
    alternate_names: List.t,
    years: integer,
    csr: String.t,
    state: String.t,
    authority_identifier: String.t,
    auto_renew: boolean,
    created_at: String.t,
    updated_at: String.t,
    expires_at: String.t,

    private_key: String.t,
    server: String.t,
    root: String.t,
    chain: String.t,
  }

  defstruct ~w(id domain_id contact_id
               common_name alternate_names years csr state authority_identifier auto_renew
               created_at updated_at expires_at
               server root chain private_key)a

end
