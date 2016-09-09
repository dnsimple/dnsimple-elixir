defmodule Dnsimple.TemplatesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Templates
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  describe ".list_templates" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/templates"
      {:ok, fixture: "listTemplates/success.http", method: "get", url: url}
    end

    test "returns the templates in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.list_templates(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Template end)
      end
    end

    test "supports custom headers", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_templates(@client, @account_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture_file, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/templates?sort=name%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_templates(@client, @account_id, sort: "name:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "it can be called using the alias .templates", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.templates(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end

end
