defmodule Dnsimple.Utils do

  @doc """
  Converts a ap into a struct.

  This function is similar to `Kernel.struct/2`, however it handles
  the case where the struct fields are defined with atoms, and the map
  uses strings as keys.

  It also handles the conversion of nested attribute maps into structs.
  This can only be done at the top level.

  This is correct and will work:

      attrs = %{"a" => "b", "c" => %{"d" => "e"}}
      attrs_to_struct(attrs, MyStruct, c: MyNestedStruct)

  Where this is not correct and will not be converted correctly:

      attrs = %{"a" => "b", "c" => %{"d" => %{"e" => "f"}}}
      attrs_to_struct(attrs, MyStruct, c: MyNestedStruct, e: OtherNestedSTruct)

  Lists of maps are also converted correctly both at the top and the nested level.
  So you can do things like:

      attrs = %{"a" => "b", "c" => [%{"d" => "e"}, %{"d" => "f"}]}
      attrs_to_struct(attrs, MyStruct, c: MyNestedStruct)

  On top of this the order of the first two parameters has been swapped
  to be able to use the method in pipelines.

  ## Examples

      defmodule Address, do: defstruct [:street, :country]
      defmodule User, do: defstruct [:id, :name, :address]

      Dnsimple.Utils.attrs_to_struct(%{"name" => "weppos", "foo" => "bar"}, User)
      Dnsimple.Utils.attrs_to_struct([%{"name" => "jacegu"}, %{"name" => "weppos"}], User)
      Dnsimple.Utils.attrs_to_struct(%{"id" => 1, "address" => %{"country" => "IT"}}, User, address: Address)

  """
  @spec attrs_to_struct(Enum.t, module | map, Keyword.t) :: map
  def attrs_to_struct(attrs, kind, nested \\ [])
  def attrs_to_struct(attrs, kind, nested) when is_list(attrs) do
    Enum.map(attrs, &(attrs_to_struct(&1, kind, nested)))
  end
  def attrs_to_struct(attrs, kind, nested) do
    attributes = Enum.reduce(attrs, %{}, fn({name, value}, result) ->
      name  = String.to_atom(name)
      value = value(name, value, nested)
      Map.put(result, name, value)
    end)

    struct(kind, attributes)
  end

  defp value(key, value, nested) do
    case Keyword.get(nested, key) do
      nil         -> value
      nested_kind -> attrs_to_struct(value, nested_kind)
    end
  end


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
