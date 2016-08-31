defmodule Dnsimple.TestOptionsTest do
  use ExUnit.Case, async: true

  describe ".prepare" do
    test "empty list options results in empty params list" do
      assert Dnsimple.ListOptions.prepare([]) == []
    end

    test "includes filter if present" do
      assert Dnsimple.ListOptions.prepare([filter: [name_like: "example"]]) == [params: [name_like: "example"]]
    end

    test "includes sort if it present" do
      assert Dnsimple.ListOptions.prepare([sort: "foo:asc"]) == [params: [sort: "foo:asc"]]
    end

    test "includes page if it present" do
      assert Dnsimple.ListOptions.prepare([page: 1]) == [params: [page: 1]]
    end

    test "includes per page if present" do
      assert Dnsimple.ListOptions.prepare([per_page: 1]) == [params: [per_page: 1]]
    end

    test "combines options correctly" do
      assert Dnsimple.ListOptions.prepare([per_page: 1, sort: "foo:asc"]) == [params: [per_page: 1, sort: "foo:asc"]]
    end

    test "mantains other options" do
      assert Dnsimple.ListOptions.prepare([sort: "foo:asc", other: "foo"]) == [params: [sort: "foo:asc"], other: "foo"]
    end
  end

end
