defmodule Dnsimple.Charge do
  require Decimal
  @moduledoc """
  Represents a billing charge.

  See:
  - https://developer.dnsimple.com/v2/billing/
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    invoiced_at: DateTime.t,
    total_amount: Decimal.t,
    balance_amount: Decimal.t,
    reference: String.t,
    state: String.t,
    items: [ChargeItem.t],
  }

  defstruct ~w(invoiced_at total_amount balance_amount reference state items)a

  def new(attrs) do
    attrs = Map.put(attrs, :total_amount, Decimal.new(attrs.total_amount))
    attrs = Map.put(attrs, :balance_amount, Decimal.new(attrs.balance_amount))
    attrs = Map.put(attrs, :items, Enum.map(attrs.items, &Dnsimple.Charge.ChargeItem.new/1))
    struct(__MODULE__, attrs)
  end

  defimpl Poison.Decoder, for: __MODULE__ do
    @spec decode(Dnsimple.Charge.t(), any()) :: struct()
    def decode(value, _opts) do
      Map.from_struct(value)
      |> Dnsimple.Charge.new()
    end
  end

  defmodule ChargeItem do
    @moduledoc """
    Represents a billing charge item.

    See:
    - https://developer.dnsimple.com/v2/billing
    """
    @moduledoc section: :data_types

    @type t :: %__MODULE__{
      description: String.t,
      amount: Decimal.t,
      product_id: integer | nil,
      product_type: String.t,
      product_reference: String.t | nil,
    }

    defstruct ~w(description amount product_id product_type product_reference)a

    def new(attrs) do
      attrs = Map.new(attrs, fn({k, v}) -> {String.to_atom(k), v} end)
      attrs = Map.put(attrs, :amount, Decimal.new(attrs.amount))
      struct(__MODULE__, attrs)
    end
  end
end
