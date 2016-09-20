defmodule Dnsimple do

  def start, do: :application.ensure_all_started(:httpoison)


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

    @doc"""
    Returns the representation of an empty body in a request.

    ## Examples
       iex> Dnsimple.Client.empty_body
       nil

    """
    @spec empty_body :: nil
    def empty_body, do: nil

    @doc """
    Issues a GET request to the given url.
    """
    @spec get(Client.t, binary, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def get(client, url, options \\ []), do: execute(client, :get, url, empty_body, options)

    @doc """
    Issues a POST request to the given url.
    """
    @spec post(Client.t, binary, body, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def post(client, url, body, options \\ []), do: execute(client, :post, url, body, options)

    @doc """
    Issues a PUT request to the given url.
    """
    @spec put(Client.t, binary, body, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def put(client, url, body, options \\ []), do: execute(client, :put, url, body, options)

    @doc """
    Issues a PATCH request to the given url.
    """
    @spec patch(Client.t, binary, body, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def patch(client, url, body, options \\ []), do: execute(client, :patch, url, body, options)

    @doc """
    Issues a DELETE request to the given url.
    """
    @spec delete(Client.t, binary, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def delete(client, url, options \\ []), do: execute(client, :delete, url, empty_body, options)

    def execute(client, method, url, body \\ "", all_options \\ []) do
      {headers, options} = split_headers_options(client, all_options)
      {headers, body}    = process_request_body(headers, body)

      HTTPoison.request!(method, url(client, url), body, headers, options)
      |> check_response
    end

    defp split_headers_options(client, all_options) do
      default_headers = %{
        "Accept"        => "application/json",
        "User-Agent"    => format_user_agent(client.user_agent),
        "Authorization" => "Bearer #{client.access_token}",
      }

      {headers, options} = Keyword.pop(all_options, :headers)

      case headers do
        nil     -> {default_headers, options}
        headers -> {Map.merge(default_headers, Enum.into(headers, %{})), options}
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

    defp process_request_body(headers, nil), do: {headers, []}
    defp process_request_body(headers, body) when is_binary(body), do: {headers, body}
    defp process_request_body(headers, body) do
      case get_header(headers, "Accept") do
        {_, "application/json"} -> {Map.put(headers, "Content-Type", "application/json"), Poison.encode!(body)}
        _                       -> {headers, body}
      end
    end

    defp url(%Client{base_url: base_url}, path) do
      base_url <> path
    end

    defp check_response(http_response) do
      case http_response.status_code  do
        i when i in 200..299 -> {:ok, http_response}
        404 -> {:error, NotFoundError.new(http_response)}
        _   -> {:error, RequestError.new(http_response)}
      end
    end
  end


  defmodule Listing do
    @doc """
    Issues a GET request to the given url processing the listing options first.
    """
    @spec get(Client.t, binary, Keyword.t) :: HTTPoison.Response.t | HTTPoison.AsyncResponse.t
    def get(client, url, options \\ []), do: Client.get(client, url, format(options))


    @known_params ~w(filter sort page per_page)a

    @doc """
    Format request options for list endpoints into HTTP params.
    """
    def format(options) do
      {params, options} = Enum.reduce(@known_params, {[], options}, &extract_param/2)

      case Enum.empty?(params) do
        true  -> options
        false -> Keyword.merge([params: params], options)
      end
    end

    defp extract_param(:filter = option, {params, options}) do
      case Keyword.has_key?(options, option) do
        true ->
          value   = Keyword.get(options, option)
          params  = Keyword.merge(params, value)
          options = Keyword.delete(options, option)
          {params, options}
        false ->
          {params, options}
      end
    end
    defp extract_param(option, {params, options}) do
      case Keyword.has_key?(options, option) do
        true ->
          value   = Keyword.get(options, option)
          params  = Keyword.put(params, option, value)
          options = Keyword.delete(options, option)
          {params, options}
        false ->
          {params, options}
      end
    end


    @first_page 1
    @unkown_pages_left nil

    @doc """
    Iterates over all pages of a listing endpoint and returns the union of all
    the elements of all pages in the form of `{:ok, all_elements}`.  If an
    error occurs it will return the response to the request that failed in the
    form of `{:error, failed_response}`.

    Note that the `params` attribute must include the `options` parameter even
    if it's optional.

    ## Examples

      client     = %Dnsimple.Client{access_token: "a1b2c3d4"}
      account_id = 1010

      Listing.get_all(Dnsimple.Zones, :list_zones, [client, account_id, []])
      Listing.get_all(Dnsimple.Zones, :list_zones, [client, account_id, [sort: "name:desc"]])
      Listing.get_all(Dnsimple.Zones, :list_zone_records, [client, account_id, _zone_id = "example.com", []])

    """
    def get_all(module, function, params) do
      get_pages(module, function, params, _all = [], _page = @first_page, _pages_left = @unkown_pages_left)
    end

    defp get_pages(_module, _function, _params, all, _page, _pages_left = 0), do: {:ok, all}
    defp get_pages(module, function, params, all, page, pages_left)do
      case apply(module, function, add_page_param(params, page)) do
        {:ok, response} ->
          all        = all ++ response.data
          next_page  = page + 1
          pages_left = response.pagination.total_pages - page
          get_pages(module, function, params, all, next_page, pages_left)
        {:error, response} -> {:error, response}
      end
    end

    defp add_page_param(params, page) do
      arity   = Enum.count(params)
      options = List.last(params) ++ [page: page]
      List.replace_at(params, arity - 1, options)
    end

  end
end
