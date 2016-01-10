defmodule Dnsimple do

  defmodule Client do
    @base_url "https://api.dnsimple.com/"
    @user_agent "dnsimple-elixir/#{Dnsimple.Mixfile.project[:version]}"

    @api_version "v2"

    defstruct access_token: nil, base_url: @base_url
    @type t :: %__MODULE__{access_token: String.t, base_url: String.t}


    @doc """
    Prepends the correct API version to path.

    ## Examples

        iex> Dnsimple.Client.versioned "whoami"
        "v2/whoami"

    """
    @spec versioned(String.t) :: String.t
    def versioned(path) do
      @api_version <> "/" <> path
    end


    @spec url(Client.t, String.t) :: String.t
    defp url(client = %Client{base_url: base_url}, path) do
      base_url <> path
    end


    @doc """
    Issues a GET request to the given url.
    """
    def get(client, url, headers \\ [], options \\ []), do: request(client, :get, url, "", headers, options)

    def request(client, method, url, body \\ "", headers \\ [], options \\ []) do
      headers = headers ++ [
        {"Accept", "application/json"},
        {"User-Agent", @user_agent},
        {"Authorization", "Bearer #{client.access_token}"},
      ]
      HTTPoison.request!(method, url(client, url), body, headers, options)
    end

  end

end

