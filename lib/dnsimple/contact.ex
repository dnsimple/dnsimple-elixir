defmodule Dnsimple.Contact do
  @moduledoc """
  Represents a DNSimple contact.

  See: https://developer.dnsimple.com/v2/contacts/
  """

  @type t :: %__MODULE__{
    id: integer,
    account_id: integer,
    label: String.t,
    first_name: String.t,
    last_name: String.t,
    email: String.t,
    phone: String.t,
    fax: String.t,
    address1: String.t,
    address2: String.t,
    city: String.t,
    state_province: String.t,
    postal_code: String.t,
    country: String.t,
    job_title: String.t,
    organization_name: String.t,
    created_at: DateTime.t,
    updated_at: DateTime.t,
  }

  defstruct ~w(id account_id label first_name last_name email phone fax
               address1 address2 city state_province postal_code country
               job_title organization_name created_at updated_at)a

end

defimpl Poison.Decoder, for: Dnsimple.Contact do
  use Dnsimple.Decoder.Timestamps

  @spec decode(Dnsimple.Contact.t, Keyword.t) :: Dnsimple.Contact.t
  def decode(entity, _), do: entity
end
