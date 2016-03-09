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
    @base_url "https://api.dnsimple.com"
    @user_agent "dnsimple-elixir/#{Dnsimple.Mixfile.project[:version]}"

    @api_version "v2"
    @wildcard_account "_"

    defstruct access_token: nil, base_url: @base_url
    @type t :: %__MODULE__{access_token: String.t, base_url: String.t}

    alias Dnsimple.RequestError

    @type headers :: [{binary, binary}] | %{binary => binary}
    @type body :: binary | {:form, [{atom, any}]} | {:file, binary}

    def __WILDCARD_ACCOUNT__, do: @wildcard_account


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
        {"User-Agent", @user_agent},
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

end
