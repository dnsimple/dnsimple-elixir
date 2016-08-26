defmodule DnsimpleTest do
  use ExUnit.Case, async: true
  doctest Dnsimple

  test "empty list options results in empty params list" do
    assert Dnsimple.ListOptions.prepare([]) == []
  end

  test "list options include filter if it is present" do
    assert Dnsimple.ListOptions.prepare([filter: [name_like: "example"]]) == [params: [name_like: "example"]]
  end

  test "list options include sort if it is present" do
    assert Dnsimple.ListOptions.prepare([sort: "foo:asc"]) == [params: [sort: "foo:asc"]]
  end

  test "list options include page if it is present" do
    assert Dnsimple.ListOptions.prepare([page: 1]) == [params: [page: 1]]
  end

  test "list options include per page if it is present" do
    assert Dnsimple.ListOptions.prepare([per_page: 1]) == [params: [per_page: 1]]
  end

end
