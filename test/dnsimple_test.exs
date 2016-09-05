defmodule Dnsimple.ClientTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Client

  test "initialize with defaults" do
    client = %Dnsimple.Client{}
    assert client.access_token == nil
    assert client.base_url == "https://api.dnsimple.com"
  end


  describe ".versioned" do
    test "joins path with current api version" do
      assert Dnsimple.Client.versioned("/whoami") == "/v2/whoami"
    end
  end

  describe ".execute" do
    setup do
      client  = %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
      url     = "#{client.base_url}/v2/1010/domains"
      fixture = ExvcrUtils.response_fixture("listDomains/success.http", method: "get", url: url)

      {:ok, client: client, fixture: fixture}
    end

    test "handles headers defines as a map", %{client: client, fixture: fixture} do
      use_cassette :stub, fixture  do
        {:ok, response} = Dnsimple.Domains.domains(client, "1010", headers: %{page: 2})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "handles headers defines as a list", %{client: client, fixture: fixture} do
      use_cassette :stub, fixture  do
        {:ok, response} = Dnsimple.Domains.domains(client, "1010", headers: [{"X-Header", "X-Value"}])
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end

end

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
