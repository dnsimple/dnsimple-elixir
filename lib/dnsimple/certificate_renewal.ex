defmodule Dnsimple.CertificateRenewal do
  @moduledoc """
  Represents a Certificate Renewal order.
  """

  @type t :: %__MODULE__{
    id: integer,
    old_certificate_id: integer,
    new_certificate_id: integer,
    state: String.t,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id old_certificate_id new_certificate_id state
               created_at updated_at)a

end
