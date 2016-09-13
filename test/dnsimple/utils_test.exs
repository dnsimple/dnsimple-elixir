defmodule Dnsimple.UtilsTest do
  use ExUnit.Case, async: true
  doctest Dnsimple.Utils

  defmodule TestStruct, do: defstruct [:id, :name, :nested]
  defmodule TestNestedStruct, do: defstruct [:description]

  describe ".attrs_to_struct" do
    test "works with string-keyed maps" do
      struct = Dnsimple.Utils.attrs_to_struct(%{"name" => "weppos", "foo" => "bar"}, TestStruct)
      assert struct == %TestStruct{id: nil, name: "weppos"}
    end

    test "works with lists of string-keyed maps" do
      structs = Dnsimple.Utils.attrs_to_struct([%{"name" => "weppos", "foo" => "bar"}], TestStruct)
      assert structs == [%TestStruct{id: nil, name: "weppos"}]
    end

    test "handles nested struct types" do
      attrs  = %{"name" => "weppos", "nested" => %{"description" => "a"}}
      struct = Dnsimple.Utils.attrs_to_struct(attrs, TestStruct, nested: TestNestedStruct)
      assert struct == %TestStruct{id: nil, name: "weppos", nested: %TestNestedStruct{description: "a"}}
    end

    test "handles lists of nested struct types" do
      attrs    = %{"name" => "weppos", "nested" => [%{"description" => "a"}, %{"description" => "b"}]}
      expected = %TestStruct{
        id: nil,
        name: "weppos",
        nested: [%TestNestedStruct{description: "a"}, %TestNestedStruct{description: "b"}]
      }
      assert Dnsimple.Utils.attrs_to_struct(attrs, TestStruct, nested: TestNestedStruct) == expected
    end
  end

end
