defmodule DnsimpleUtilsTest do
  use ExUnit.Case, async: true
  doctest Dnsimple.Utils

  defmodule TestStruct, do: defstruct [:id, :name]

  test ".attrs_to_struct" do
    struct = Dnsimple.Utils.attrs_to_struct(%{"name" => "weppos", "foo" => "bar"}, __MODULE__.TestStruct)
    assert struct == %__MODULE__.TestStruct{id: nil, name: "weppos"}
  end

  test ".attrs_to_structs" do
    structs = Dnsimple.Utils.attrs_to_structs([%{"name" => "weppos", "foo" => "bar"}], __MODULE__.TestStruct)
    assert structs == [%__MODULE__.TestStruct{id: nil, name: "weppos"}]
  end

end
