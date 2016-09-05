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

  @spec build_response(HTTPoison.Response.t, any, Dnsimple.Response.Pagination) :: Response.t
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

  def parse({:error, http_response}, _) do
    {:error, http_response}
  end
  def parse({:ok, http_response}, kind) do
    response_map = decode(http_response)

    data = transform_to_struct(response_map, kind)
    pagination = extract_pagination(response_map)

    {:ok, build_response(http_response, data, pagination)}
  end

  defp transform_to_struct(_, nil), do: nil
  defp transform_to_struct(%{"data" => attributes}, kind), do: to_struct(attributes, kind)
  defp transform_to_struct(attributes , kind),             do: to_struct(attributes, kind)

  defp extract_pagination(%{"pagination" => pagination}) do
    %Dnsimple.Response.Pagination{
      current_page: pagination["current_page"],
      per_page: pagination["per_page"],
      total_entries: pagination["total_entries"],
      total_pages: pagination["total_pages"]
    }
  end
  defp extract_pagination(_), do: nil

  def decode(%HTTPoison.Response{body: ""}), do: %{}
  def decode(%HTTPoison.Response{body: body}), do: Poison.decode!(body)

  defp to_struct(attrs, kind) when is_list(attrs), do: Dnsimple.Utils.attrs_to_structs(attrs, kind)
  defp to_struct(attrs, kind), do: Dnsimple.Utils.attrs_to_struct(attrs, kind)

end
