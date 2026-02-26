defmodule Dnsimple.DomainResearchStatus do
  @moduledoc """
  Represents the result of a domain research.

  See:
  - https://developer.dnsimple.com/v2/domains/research/#getDomainsResearchStatus
  """
  @moduledoc section: :data_types

  @type t :: %__MODULE__{
    request_id: String.t,
    domain: String.t,
    availability: String.t,
    errors: [String.t],
  }

  defstruct ~w(request_id domain availability errors)a
end
