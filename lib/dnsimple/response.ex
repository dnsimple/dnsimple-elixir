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


  def data(http_response, kind) do
    attrs = decode(http_response)
    |> Map.get("data")

    case kind do
      [t] -> Dnsimple.Utils.attrs_to_structs(attrs, t)
       t  -> Dnsimple.Utils.attrs_to_struct(attrs, t)
    end
  end


  def decode(http_response) do
    http_response.body
    |> Poison.decode!
  end

end
