defmodule Dnsimple.ContactsTest do
  use TestCase, async: false

  @module Dnsimple.Contacts

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_contacts" do
    test "returns the contacts in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/1010/contacts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listContacts/success.http")
      end)

      {:ok, response} = @module.list_contacts(client, "1010")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn contact -> contact.__struct__ == Dnsimple.Contact end)
      assert Enum.all?(data, fn contact -> is_integer(contact.id) end)
    end

    test "supports custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/1010/contacts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listContacts/success.http")
      end)

      {:ok, response} =
        @module.list_contacts(client, "1010", headers: %{"X-Header" => "X-Value"})

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/1010/contacts", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listContacts/success.http")
      end)

      {:ok, response} = @module.list_contacts(client, "1010", sort: "label:asc")
      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".contact" do
    test "returns the contact in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/1010/contacts/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getContact/success.http")
      end)

      {:ok, response} = @module.get_contact(client, 1010, 1)
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
      assert contact.created_at == "2016-01-19T20:50:26Z"
      assert contact.updated_at == "2016-01-19T20:50:26Z"
    end
  end

  describe ".create_contact" do
    test "creates the contact and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
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

      Bypass.expect_once(bypass, "POST", "/v2/1010/contacts", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "createContact/created.http")
      end)

      {:ok, response} = @module.create_contact(client, 1010, attributes)
      assert response.__struct__ == Dnsimple.Response

      contact = response.data
      assert contact.__struct__ == Dnsimple.Contact
    end
  end

  describe ".update_contact" do
    test "updates the contact and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{label: "Default"}

      Bypass.expect_once(bypass, "PATCH", "/v2/1010/contacts/1", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "updateContact/success.http")
      end)

      {:ok, response} = @module.update_contact(client, 1010, 1, attributes)
      assert response.__struct__ == Dnsimple.Response

      contact = response.data
      assert contact.__struct__ == Dnsimple.Contact
      assert contact.label == "Default"
    end
  end

  describe ".delete_contact" do
    test "deletes the contact", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "DELETE", "/v2/1010/contacts/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "deleteContact/success.http")
      end)

      {:ok, response} = @module.delete_contact(client, 1010, 1)
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end
end
