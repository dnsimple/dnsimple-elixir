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
        {:ok, created_at, _} = DateTime.from_iso8601(created_at)
        decode(%{entity | created_at: created_at}, options)
      end
      def decode(%{updated_at: updated_at} = entity, options) when is_binary(updated_at) do
        {:ok, updated_at, _} = DateTime.from_iso8601(updated_at)
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
