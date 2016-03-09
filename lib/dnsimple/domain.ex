defmodule Dnsimple.Domain do
  @moduledoc """
  Represents a [DNSimple domain](https://developer.dnsimple.com/v2/domains/#domain-attributes).
  """

  @fields [
    :id, :account_id, :registrant_id,
    :name, :token, :state,
    :auto_renew, :private_whois,
    :expired_on, :created_at, :updated_at,
  ]

  @type t :: %__MODULE__{
    id: integer, account_id: integer, registrant_id: integer,
    name: String.t, token: String.t, state: String.t,
    auto_renew: boolean, private_whois: boolean,
    expired_on: String.t, created_at: String.t, updated_at: String.t,
  }

  defstruct @fields

end
