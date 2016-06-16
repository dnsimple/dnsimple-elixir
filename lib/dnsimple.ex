defmodule Dnsimple do

  defmodule Error do
    def decode(body) do
      Poison.decode!(body)
    end
  end

  defmodule RequestError do
    @moduledoc """
    Error raised when an API request fails for an client, a server error or
    invalid request information.
    """

    alias Dnsimple.Error
    defexception [:message, :http_response]

    def new(http_response) do
      message = Error.decode(http_response.body) |> Map.get("message")

      %__MODULE__{
        message: "HTTP #{http_response.status_code}: #{message}",
        http_response: http_response
      }
    end
  end

  defmodule NotFoundError do
    @moduledoc """
    Error raised when the target of an API request is not found.
    """

    alias Dnsimple.Error
    defexception [:message, :http_response]

    def new(http_response) do
      %__MODULE__{
        message: Error.decode(http_response.body) |> Map.get("message"),
        http_response: http_response
      }
    end
  end

  defmodule Client do
    @default_base_url "https://api.dnsimple.com"
    @default_user_agent "dnsimple-elixir/#{Dnsimple.Mixfile.project[:version]}"

    @api_version "v2"

    defstruct access_token: nil, base_url: @default_base_url, user_agent: nil
    @type t :: %__MODULE__{access_token: String.t, base_url: String.t, user_agent: String.t}

    alias Dnsimple.RequestError

    @type headers :: [{binary, binary}] | %{binary => binary}
    @type body :: binary | {:form, [{atom, any}]} | {:file, binary}


    @doc """
    Prepends the correct API version to path.

    ## Examples

        iex> Dnsimple.Client.versioned "/whoami"
        "/v2/whoami"

    """
    @spec versioned(String.t) :: String.t
    def versioned(path) do
      "/" <> @api_version <> path
    end

    @spec headers(Keyword.t) :: {t, t}
    def headers(options) do
      Keyword.split(options, [:headers])
    end


    @spec url(Client.t, String.t) :: String.t
    defp url(%Client{base_url: base_url}, path) do
      base_url <> path
    end

    @doc """
    Issues a GET request to the given url.
    """
    @spec get(Client.t, binary, headers, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def get(client, url, headers \\ [], options \\ []), do: execute(client, :get, url, "", headers, options)

    @doc """
    Issues a POST request to the given url.
    """
    @spec post(Client.t, binary, body, headers, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def post(client, url, body, headers \\ [], options \\ []), do: execute(client, :post, url, body, headers, options)

    @doc """
    Issues a PUT request to the given url.
    """
    @spec put(Client.t, binary, body, headers, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def put(client, url, body, headers \\ [], options \\ []), do: execute(client, :put, url, body, headers, options)

    @doc """
    Issues a PATCH request to the given url.
    """
    @spec patch(Client.t, binary, body, headers, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def patch(client, url, body, headers \\ [], options \\ []), do: execute(client, :patch, url, body, headers, options)

    @doc """
    Issues a DELETE request to the given url.
    """
    @spec delete(Client.t, binary, headers, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def delete(client, url, headers \\ [], options \\ []), do: execute(client, :delete, url, "", headers, options)


    def execute(client, method, url, body \\ "", headers \\ [], options \\ []) do
      headers = headers ++ [
        {"Accept", "application/json"},
        {"User-Agent", format_user_agent(client.user_agent)},
        {"Authorization", "Bearer #{client.access_token}"},
      ]

      { body, headers } = process_request_body(body, headers)

      request(client, method, url, body, headers, options)
      |> check_response
    end

    @doc """
    Sends an HTTP request and returns an HTTP response.
    """
    def request(client, method, url, body \\ "", headers \\ [], options \\ []) do
      HTTPoison.request!(method, url(client, url), body, headers, options)
    end

    def check_response(http_response) do
      case http_response.status_code  do
        i when i in 200..299 -> { :ok, http_response }
        404 -> { :error, NotFoundError.new(http_response) }
        _   -> { :error, RequestError.new(http_response) }
      end
    end

    # Builds the final user agent to use for HTTP requests.
    #
    # If no custom user agent is provided, the default user agent is used.
    #
    #     dnsimple-elixir/1.0
    #
    # If a custom user agent is provided, the final user agent is the combination
    # of the custom user agent prepended by the default user agent.
    #
    #     dnsimple-elixir/1.0 customAgentFlag
    #
    defp format_user_agent(nil), do: @default_user_agent
    defp format_user_agent(custom_agent) do
      "#{@default_user_agent} #{custom_agent}"
    end

    # Extracts a specific {"Name", "Value"} header tuple.
    defp get_header(headers, name) do
      Enum.find(headers, fn({key, _}) -> key == name end)
    end

    defp process_request_body(nil,  headers), do: { nil, headers }
    defp process_request_body(body, headers) when is_binary(body), do: { body, headers }
    defp process_request_body(body, headers) do
      case get_header(headers, "Accept") do
        { _, "application/json" } -> { Poison.encode!(body), [{"Content-Type", "application/json"}|headers] }
        _ -> { body, headers }
      end
    end

  end

  defmodule ListOptions do
    @doc """
    Convert options for list endpoints into HTTP params
    """
    def prepare(options) do
      if Enum.empty?(options) do
        options
      else
        result = Keyword.get(options, :filter, [])
        sort   = Keyword.get(options, :sort)
        unless is_nil(sort) do
          result = Keyword.merge(result, [sort: sort])
        end

        [params: result]
      end
    end
  end

end
