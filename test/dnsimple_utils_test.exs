defmodule DnsimpleUtilsTest do
  use ExUnit.Case, async: true
  doctest Dnsimple.Utils

  defmodule TestStruct, do: defstruct [:id, :name]

  test ".map_to_struct" do
    struct = Dnsimple.Utils.map_to_struct(%{"name" => "weppos", "foo" => "bar"}, __MODULE__.TestStruct)
    assert struct == %__MODULE__.TestStruct{id: nil, name: "weppos"}
  end

end

