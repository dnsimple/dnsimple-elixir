defmodule Dnsimple.Response do
  defstruct [
    :http_response, :data,
    :rate_limit, :rate_limit_remaining, :rate_limit_reset,
  ]
  @type t :: %__MODULE__{
    http_response: HTTPoison.Response.t, data: any,
    rate_limit: integer, rate_limit_remaining: integer, rate_limit_reset: integer
  }


  @doc """
  Creates a response from an HTTPoison response and parsed data.
  """
  @spec new(HTTPoison.Response.t, any) :: Response.t
  def new(http_response, data \\ nil) do
    headers = Enum.into(http_response.headers, %{})

    %__MODULE__{
      http_response: http_response, data: data,
      rate_limit: String.to_integer(headers["X-RateLimit-Limit"]),
      rate_limit_remaining: String.to_integer(headers["X-RateLimit-Remaining"]),
      rate_limit_reset: String.to_integer(headers["X-RateLimit-Reset"]),
    }
  end

  def parse({:error, http_response}, _) do
    {:error, http_response}
  end
  def parse({:ok, http_response}, nil) do
    {:ok, new(http_response, nil) }
  end
  def parse({:ok, http_response}, kind) do
    data = decode(http_response)
    |> Map.get("data")
    |> to_struct(kind)

    {:ok, new(http_response, data)}
  end

  def decode(%HTTPoison.Response{ body: "" }), do: %{}
  def decode(%HTTPoison.Response{ body: body }), do: Poison.decode!(body)

  defp to_struct(attrs, kind) when is_list(attrs), do: Dnsimple.Utils.attrs_to_structs(attrs, kind)
  defp to_struct(attrs, kind), do: Dnsimple.Utils.attrs_to_struct(attrs, kind)

end
