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

  @type t :: %__MODULE__{
    id: integer,
    domain_id: integer,
    name: String.t,
    common_name: String.t,
    years: integer,
    csr: String.t,
    state: String.t,
    authority_identifier: String.t,
    server: String.t,
    root: String.t,
    chain: String.t,
    private_key: String.t,
    expires_on: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id domain_id name common_name years csr state
               authority_identifier server root chain private_key expires_on
               created_at updated_at)a

end
