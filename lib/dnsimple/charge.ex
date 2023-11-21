defmodule Dnsimple.Charge do
  @moduledoc """
  Represents a billing charge.

  See:
  - https://developer.dnsimple.com/v2/billing/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    invoiced_at: DateTime.t,
    total_amount: Decimal.t | String.t | nil,
    balance_amount: Decimal.t | String.t | nil,
    reference: String.t,
    state: String.t,
    items: [ChargeItem.t],
  }

  defstruct ~w(invoiced_at total_amount balance_amount reference state items)a

  defmodule ChargeItem do
    @moduledoc """
    Represents a billing charge item.

    See:
    - https://developer.dnsimple.com/v2/billing
    """
    @moduledoc section: :data_types

    @type t :: %__MODULE__{
      description: String.t,
      amount: Decimal.t | String.t | nil,
      product_id: integer,
      product_type: String.t,
      product_reference: String.t,
    }

    defstruct ~w(description amount product_id product_type product_reference)a
  end
end
