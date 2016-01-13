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

      Dnsimple.Utils.map_to_struct(%{"name" => "weppos", "foo" => "bar"}, User)
      %User{id: nil, name: "weppos"}

  """
  @spec map_to_struct(Enum.t, module | map) :: map
  def map_to_struct(attrs, kind) do
    struct = struct(kind)
    Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
      case Map.fetch(attrs, Atom.to_string(k)) do
        {:ok, v} -> %{acc | k => v}
        :error -> acc
      end
    end
  end

end
