defmodule Dnsimple.ContactTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias Dnsimple.Contact

  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  describe ".contacts" do
    setup do
      url     = "#{@client.base_url}/v2/1010/contacts"
      method  = "get"
      fixture = "listContacts/success.http"

      {:ok, fixture: fixture, method: method, url: url}
    end

    test "builds the correct request", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = Contact.contacts(@client, "1010")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports custom headers", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = Contact.contacts(@client, "1010", headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture_file, method: method} do
      url = "#{@client.base_url}/v2/1010/contacts?sort=label%3Aasc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = Contact.contacts(@client, "1010", sort: "label:asc")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end

end
