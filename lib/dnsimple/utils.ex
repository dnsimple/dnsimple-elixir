defmodule Dnsimple.Utils do

  @doc """
  Converts the map into a struct.

  This function is similar to `Kernel.struct/2`, however it handles
  the case where the struct fields are defined with atoms, and the map
  instead is passed with keys as strings.

  Moreover, compared to `struct/2` the order of the parameter is swapped
  so that it's possible to use the `|>` operator pipelining the map.

  ## Examples

      defmodule User, do: defstruct [:id, :name]
      {:module, User, _, %User{id: nil, name: nil}}

      Dnsimple.Utils.single_to_struct(%{"name" => "weppos", "foo" => "bar"}, User)
      %User{id: nil, name: "weppos"}

  """
  @spec single_to_struct(Enum.t, module | map) :: map
  def single_to_struct(attrs, kind) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

  @spec collection_to_struct(List.t, module | map) :: map
  def collection_to_struct(collection, kind) do
    Enum.map(collection, fn(x) -> single_to_struct(x, kind) end)
  end


  # http://michal.muskala.eu/2015/07/30/unix-timestamps-in-elixir.html
  defmodule DateTime do
    epoch = {{1970, 1, 1}, {0, 0, 0}}
    @epoch :calendar.datetime_to_gregorian_seconds(epoch)

    def from_timestamp(timestamp) do
      timestamp
      |> +(@epoch)
      |> :calendar.gregorian_seconds_to_datetime
    end

    def to_timestamp(datetime) do
      datetime
      |> :calendar.datetime_to_gregorian_seconds
      |> -(@epoch)
    end
  end

end
