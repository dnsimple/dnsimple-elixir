defmodule Dnsimple.ListTest do
  use ExUnit.Case, async: true

  alias Dnsimple.List

  describe ".format" do
    test "empty list options results in empty params list" do
      assert List.format([]) == []
    end

    test "empty list options with other options results in no params list" do
      assert List.format([headers: [{"X-Header", "X-Value"}]]) == [headers: [{"X-Header", "X-Value"}]]
    end

    test "includes filter if present" do
      assert List.format([filter: [name_like: "example"]]) == [params: [name_like: "example"]]
    end

    test "includes sort if it present" do
      assert List.format([sort: "foo:asc"]) == [params: [sort: "foo:asc"]]
    end

    test "includes page if it present" do
      assert List.format([page: 1]) == [params: [page: 1]]
    end

    test "includes per page if present" do
      assert List.format([per_page: 1]) == [params: [per_page: 1]]
    end

    test "combines options correctly" do
      assert List.format([per_page: 1, sort: "foo:asc"]) == [params: [per_page: 1, sort: "foo:asc"]]
    end

    test "mantains other options" do
      assert List.format([sort: "foo:asc", other: "foo"]) == [params: [sort: "foo:asc"], other: "foo"]
    end
  end

end
