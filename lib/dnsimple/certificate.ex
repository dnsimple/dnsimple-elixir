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
    contact_id: integer,
    common_name: String.t,
    alternate_names: List.t,
    years: integer,
    csr: String.t,
    state: String.t,
    authority_identifier: String.t,
    auto_renew: boolean,
    created_at: DateTime.t,
    updated_at: DateTime.t,
    expires_on: Date.t,

    private_key: String.t,
    server: String.t,
    root: String.t,
    chain: String.t,
  }

  defstruct ~w(id domain_id contact_id
               common_name alternate_names years csr state authority_identifier auto_renew
               created_at updated_at expires_on
               server root chain private_key)a

end

defimpl Poison.Decoder, for: Dnsimple.Certificate do
  use Dnsimple.Decoder.Timestamps
  use Dnsimple.Decoder.Expires

  @spec decode(Dnsimple.Certificate.t, Keyword.t) :: Dnsimple.Certificate.t
  def decode(entity, _), do: entity
end
