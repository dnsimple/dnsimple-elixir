defmodule Dnsimple.Response do
  defstruct [
    :http_response, :data,
    :pagination,
    :rate_limit, :rate_limit_remaining, :rate_limit_reset,
  ]
  @type t :: %__MODULE__{
    http_response: HTTPoison.Response.t, data: any,
    pagination: Dnsimple.Response.Pagination,
    rate_limit: integer, rate_limit_remaining: integer, rate_limit_reset: integer
  }

  defmodule Pagination do
    defstruct [
      :current_page, :per_page, :total_pages, :total_entries
    ]
    @type t :: %__MODULE__{
      current_page: integer, per_page: integer, total_pages: integer, total_entries: integer
    }
  end

  def parse({:error, http_response}, _format), do: {:error, http_response}
  def parse({:ok, http_response}, format) do
    body       = decode(http_response, format)
    data       = extract_data(body)
    pagination = extract_pagination(body)

    {:ok, build_response(http_response, data, pagination)}
  end

  defp decode(%HTTPoison.Response{body: ""}, _format),  do: nil
  defp decode(%HTTPoison.Response{body: body}, nil),    do: Poison.decode!(body)
  defp decode(%HTTPoison.Response{body: body}, format), do: Poison.decode!(body, as: format)

  defp extract_data(%{"data" => data}), do: data
  defp extract_data(data),              do: data

  defp extract_pagination(%{"pagination" => pagination}), do: pagination
  defp extract_pagination(_), do: nil

  defp build_response(http_response, data, pagination) do
    headers = Enum.into(http_response.headers, %{})

    %__MODULE__{
      http_response: http_response,
      data: data,
      pagination: pagination,
      rate_limit: String.to_integer(headers["X-RateLimit-Limit"]),
      rate_limit_remaining: String.to_integer(headers["X-RateLimit-Remaining"]),
      rate_limit_reset: String.to_integer(headers["X-RateLimit-Reset"]),
    }
  end

end
