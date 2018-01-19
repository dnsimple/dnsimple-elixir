defmodule Dnsimple.CertificatePurchase do
  @moduledoc """
  Represents a Certificate Purchase order.
  """

  @type t :: %__MODULE__{
    id: integer,
    certificate_id: integer,
    state: String.t,
    auto_renew: boolean,
    created_at: String.t,
    updated_at: String.t,
  }

  defstruct ~w(id certificate_id
               state auto_renew
               created_at updated_at)a

end
