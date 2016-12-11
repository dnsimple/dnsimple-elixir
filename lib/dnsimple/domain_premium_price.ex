defmodule Dnsimple.DomainPremiumPrice do
  @moduledoc """
  Represents a premium domain price.

  See https://developer.dnsimple.com/v2/registrar/#premium-price
  """

  @type t :: %__MODULE__{
    premium_price: String.t,
    action: String.t,
  }

  defstruct ~w(premium_price action)a

end
