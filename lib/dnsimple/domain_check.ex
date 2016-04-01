defmodule Dnsimple.DomainCheck do
  defstruct [:domain, :available, :premium]
  @type t :: %__MODULE__{domain: String.t, available: Boolean.t, premium: Boolean.t}
end
