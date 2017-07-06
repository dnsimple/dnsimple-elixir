defmodule Dnsimple.Decoder.Timestamps do
  @moduledoc """
  When working with API responses containing the ususal timestamps:
  - `created_at`
  - `updated_at`
  in ISO8601 ("2014-12-06T15:56:55Z") this module defines a macro to use to add the decoding implementations.

  The protocol implementation MUST still define its own `decode/2` function.

  ## Examples:

      defimpl Poison.Decoder, for: Dnsimple.Domain do
        use Dnsimple.Decoder.Timestamps

        @spec decode(Dnsimple.Domain.t, Keyword.t) :: Dnsimple.Domain.t
        def decode(entity, _), do: entity
      end

  """
  defmacro __using__(_opts) do
    quote do
      @spec decode(map, Keyword.t) :: map
      def decode(%{created_at: created_at} = entity, options) when is_binary(created_at) do
        {:ok, created_at, _} = Dnsimple.DateTimeShim.from_iso8601(created_at)
        decode(%{entity | created_at: created_at}, options)
      end
      def decode(%{updated_at: updated_at} = entity, options) when is_binary(updated_at) do
        {:ok, updated_at, _} = Dnsimple.DateTimeShim.from_iso8601(updated_at)
        decode(%{entity | updated_at: updated_at}, options)
      end
    end
  end
end

defmodule Dnsimple.Decoder.Expires do
  @moduledoc """
  When working with API responses containing a `expires_on` date in
  ISO8601 ("2015-12-06") this module defines a macro to use to add
  the decoding implementations.

  The protocol implementation MUST still define its own `decode/2` function.

  ## Examples:

      defimpl Poison.Decoder, for: Dnsimple.Domain do
        use Dnsimple.Decoder.Expires

        @spec decode(Dnsimple.Domain.t, Keyword.t) :: Dnsimple.Domain.t
        def decode(entity, _), do: entity
      end

  """
  defmacro __using__(_opts) do
    quote do
      @spec decode(map, Keyword.t) :: map
      def decode(%{expires_on: expires_on} = entity, options) when is_binary(expires_on) do
        decode(%{entity | expires_on: Date.from_iso8601!(expires_on)}, options)
      end
    end
  end
end

# This code is borrowed from Elixir > 1.4 once this package requires => 1.4
# we should get rid of this shim and use DateTime.from_iso8601 directly!
defmodule Dnsimple.DateTimeShim do

  @moduledoc false

  def from_iso8601(<<year::4-bytes, ?-, month::2-bytes, ?-, day::2-bytes, sep,
                     hour::2-bytes, ?:, min::2-bytes, ?:, sec::2-bytes, rest::binary>>) when sep in [?\s, ?T] do
    with {year, ""} <- Integer.parse(year),
         {month, ""} <- Integer.parse(month),
         {day, ""} <- Integer.parse(day),
         {hour, ""} <- Integer.parse(hour),
         {min, ""} <- Integer.parse(min),
         {sec, ""} <- Integer.parse(sec),
         {microsec, rest} <- Calendar.ISO.parse_microsecond(rest),
         {:ok, date} <- Calendar.ISO.date(year, month, day),
         {:ok, time} <- Time.new(hour, min, sec, microsec),
         {:ok, offset} <- parse_offset(rest) do
      %{year: year, month: month, day: day} = date
      %{hour: hour, minute: minute, second: second, microsecond: microsecond} = time

      erl = {{year, month, day}, {hour, minute, second}}
      seconds = :calendar.datetime_to_gregorian_seconds(erl)
      {{year, month, day}, {hour, minute, second}} =
        :calendar.gregorian_seconds_to_datetime(seconds - offset)

      {:ok, %DateTime{year: year, month: month, day: day,
                      hour: hour, minute: minute, second: second, microsecond: microsecond,
                      std_offset: 0, utc_offset: 0, zone_abbr: "UTC", time_zone: "Etc/UTC"}, offset}
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, :invalid_format}
    end
  end

  defp parse_offset(rest) do
    case Calendar.ISO.parse_offset(rest) do
      {offset, ""} when is_integer(offset) -> {:ok, offset}
      {nil, ""} -> {:error, :missing_offset}
      _ -> {:error, :invalid_format}
    end
  end

end
