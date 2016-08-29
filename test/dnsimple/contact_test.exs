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

  describe ".create_contact" do
    test "creates the contact and returns it in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/1010/contacts"
      method  = "post"
      fixture = "createContact/created.http"
      attributes = %{
        label: "Default",
        first_name: "First",
        last_name: "User",
        job_title: "CEO",
        organization_name: "Awesome Company",
        email: "first@example.com",
        phone: "+18001234567",
        fax: "+18011234567",
        address1: "Italian Street, 10",
        city: "Roma",
        state_province: "RM",
        postal_code: "00100",
        country: "IT"
      }
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = Contact.create_contact(@client, 1010, attributes)
        assert response.__struct__ == Dnsimple.Response

        contact = response.data
        assert contact.__struct__ == Dnsimple.Contact
      end
    end
  end

  describe ".update_contact" do
    test "updates the contact and returns it in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/1010/contacts/1"
      method  = "patch"
      fixture = "updateContact/success.http"
      attributes = %{ label: "Default" }
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = Contact.update_contact(@client, 1010, 1, attributes)
        assert response.__struct__ == Dnsimple.Response

        contact = response.data
        assert contact.__struct__ == Dnsimple.Contact
        assert contact.label == "Default"
      end
    end
  end


end
