defmodule Dnsimple.TldsTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Tlds
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  describe ".list_tlds" do
    setup do
      url = "#{@client.base_url}/v2/tlds"
      {:ok, fixture: "listTlds/success.http", method: "get", url: url}
    end

    test "returns the TLDs in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.list_tlds(@client)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Tld end)
      end
    end

    test "supports custom headers", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_tlds(@client, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture_file, method: method} do
      url = "#{@client.base_url}/v2/tlds?sort=tld%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_tlds(@client, sort: "tld:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .tlds", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.tlds(@client)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_tld" do
    setup do
      url = "#{@client.base_url}/v2/tlds/com"
      {:ok, fixture: "getTld/success.http", method: "get", url: url}
    end

    test "returns the TLD in a Dnsimple.Response", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.get_tld(@client, "com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Tld
        assert data.tld == "com"
        assert data.tld_type == 1
        assert data.idn == true
        assert data.whois_privacy == true
        assert data.auto_renew_only == false
        assert data.minimum_registration == nil
      end
    end

    test "can be called using the alias .tld", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.tld(@client, "com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end

end
