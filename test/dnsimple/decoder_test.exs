defmodule Dnsimple.DecoderTest do
  use TestCase, async: true

  defmodule TestDecoder do
    use Dnsimple.Decoder.Timestamps
    use Dnsimple.Decoder.Expires

    @spec decode(map, Keyword.t) :: map
    def decode(entity, _), do: entity
  end

  setup do
    {:ok, %{created_at: "2014-12-06T15:56:55Z", updated_at: "2014-12-06T15:56:55Z", expires_on: "2015-12-06"}}
  end

  describe "Dnsimple.Decoder.Timestamps" do
    test "convert created_at to DateTime", ctx do
      assert TestDecoder.decode(ctx, []).created_at == %DateTime{calendar: Calendar.ISO, day: 6, hour: 15,
            microsecond: {0, 0}, minute: 56, month: 12, second: 55,
            std_offset: 0, time_zone: "Etc/UTC", utc_offset: 0, year: 2014,
            zone_abbr: "UTC"}
    end
    test "convert updated_at to DateTime", ctx do
      assert TestDecoder.decode(ctx, []).updated_at == %DateTime{calendar: Calendar.ISO, day: 6, hour: 15,
            microsecond: {0, 0}, minute: 56, month: 12, second: 55,
            std_offset: 0, time_zone: "Etc/UTC", utc_offset: 0, year: 2014,
            zone_abbr: "UTC"}
    end
  end

  describe "Dnsimple.Decoder.Expires" do
    test "convert created_at to DateTime", ctx do
      assert TestDecoder.decode(ctx, []).expires_on == ~D[2015-12-06]
    end
  end

end
