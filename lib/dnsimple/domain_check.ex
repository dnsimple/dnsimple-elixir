defmodule Dnsimple.DomainCheck do
  @moduledoc """
  Represent a domain check.

  See https://developer.dnsimple.com/v2/registrar/#check
  """

  @type t :: %__MODULE__{
    domain: String.t,
    available: boolean,
    premium: boolean,
  }

  defstruct ~w(domain available premium)a

end
