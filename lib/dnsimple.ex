defmodule Dnsimple do

  defmodule Client do
    @base_url "https://api.dnsimple.com/"
    @user_agent "dnsimple-elixir/#{Dnsimple.Mixfile.project[:version]}"

    @api_version "v2"

    defstruct access_token: nil, base_url: @base_url
    @type t :: %__MODULE__{access_token: String.t, base_url: String.t}
  end

end

