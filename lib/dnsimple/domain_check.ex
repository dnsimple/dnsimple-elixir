defmodule Dnsimple.DomainCheck do
  defstruct [:domain, :available, :premium]
  @type t :: %__MODULE__{domain: String.t, available: boolean, premium: boolean}
end
