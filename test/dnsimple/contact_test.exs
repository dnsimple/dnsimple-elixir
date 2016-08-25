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
        assert length(response.data) == 2
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

  describe ".contact" do
    test "returns the contact in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/1010/contacts/1"
      method  = "get"
      fixture = "getContact/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = Contact.contact(@client, 1010, 1)
        assert response.__struct__ == Dnsimple.Response

        contact = response.data
        assert contact.__struct__ == Dnsimple.Contact
        assert contact.id == 1
        assert contact.account_id == 1010
        assert contact.label == "Default"
        assert contact.first_name == "First"
        assert contact.last_name == "User"
        assert contact.job_title == "CEO"
        assert contact.organization_name == "Awesome Company"
        assert contact.email == "first@example.com"
        assert contact.phone == "+18001234567"
        assert contact.fax == "+18011234567"
        assert contact.address1 == "Italian Street, 10"
        assert contact.address2 == ""
        assert contact.city == "Roma"
        assert contact.state_province == "RM"
        assert contact.postal_code == "00100"
        assert contact.country == "IT"
        assert contact.created_at == "2016-01-19T20:50:26.066Z"
        assert contact.updated_at == "2016-01-19T20:50:26.066Z"
      end
    end
  end

end
