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
  def new(http_response, data) do
    headers = Enum.into(http_response.headers, %{})

    %__MODULE__{
      http_response: http_response, data: data,
      rate_limit: String.to_integer(headers["X-RateLimit-Limit"]),
      rate_limit_remaining: String.to_integer(headers["X-RateLimit-Remaining"]),
      rate_limit_reset: String.to_integer(headers["X-RateLimit-Reset"]),
    }
  end

end
