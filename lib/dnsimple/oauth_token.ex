defmodule Dnsimple.OauthToken do
  defstruct [:access_token, :token_type, :scope, :account_id]
  @type t :: %__MODULE__{access_token: String.t, token_type: String.t, scope: String.t, account_id: Integer.t}
end
