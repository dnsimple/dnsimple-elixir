defmodule Dnsimple.DomainPrice do
  @moduledoc """
  Represents a domain price.

  See:
  - https://developer.dnsimple.com/v2/registrar/#getDomainPrices
  """

  @type t :: %__MODULE__{
    domain: String.t,
    premium: boolean,
    registration_price: float,
    renewal_price: float,
    transfer_price: float
  }

  defstruct ~w(domain premium registration_price renewal_price transfer_price)a

end
