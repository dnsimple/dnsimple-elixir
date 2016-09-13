defmodule Dnsimple.Utils do

  # http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html
  defmodule DateTime do
    epoch = {{1970, 1, 1}, {0, 0, 0}}
    @epoch :calendar.datetime_to_gregorian_seconds(epoch)

    def from_timestamp(timestamp) do
      timestamp
      |> Kernel.+(@epoch)
      |> :calendar.gregorian_seconds_to_datetime
    end

    def to_timestamp(datetime) do
      datetime
      |> :calendar.datetime_to_gregorian_seconds
      |> Kernel.-(@epoch)
    end
  end

end
