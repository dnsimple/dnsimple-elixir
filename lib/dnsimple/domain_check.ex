defmodule Dnsimple.DomainCheck do
  @moduledoc """
  Represents a domain check.

  See:
  - https://developer.dnsimple.com/v2/registrar/#check
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    domain: String.t,
    available: boolean,
    premium: boolean,
  }

  defstruct ~w(domain available premium)a

end
