defmodule Dnsimple.OauthToken do
  @moduledoc """
  Represents an OAuth token.

  See:
  - https://developer.dnsimple.com/v2/oauth/
  - https://developer.dnsimple.com/v2/oauth/#step-2---access-token
  """

  @type t :: %__MODULE__{
    access_token: String.t,
    token_type: String.t,
    scope: String.t,
    account_id: integer,
  }

  defstruct ~w(access_token token_type scope account_id)a

end
