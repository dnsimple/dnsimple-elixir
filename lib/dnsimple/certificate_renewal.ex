defmodule Dnsimple.CertificateRenewal do
  @moduledoc """
  Represents a Certificate Renewal order.
  """

  @type t :: %__MODULE__{
    id: integer,
    old_certificate_id: integer,
    new_certificate_id: integer,
    state: String.t,
    auto_renew: boolean,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id old_certificate_id new_certificate_id
               state auto_renew
               created_at updated_at)a

end
