defmodule Dnsimple.TldsTest do
  use TestCase, async: false

  @module Dnsimple.Tlds

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_tlds" do
    test "returns the TLDs in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/tlds", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTlds/success.http")
      end)

      {:ok, response} = @module.list_tlds(client)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.Tld end)
    end

    test "supports custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/tlds", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTlds/success.http")
      end)

      {:ok, response} = @module.list_tlds(client, headers: %{"X-Header" => "X-Value"})
      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/tlds", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTlds/success.http")
      end)

      {:ok, response} = @module.list_tlds(client, sort: "tld:desc")
      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_tld" do
    test "returns the TLD in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/tlds/com", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getTld/success.http")
      end)

      {:ok, response} = @module.get_tld(client, "com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Tld
      assert data.tld == "com"
      assert data.tld_type == 1
      assert data.idn == true
      assert data.whois_privacy == true
      assert data.trustee_service_enabled == false
      assert data.trustee_service_required == false
      assert data.auto_renew_only == false
      assert data.minimum_registration == 1
      assert data.registration_enabled == true
      assert data.renewal_enabled == true
      assert data.transfer_enabled == true
      assert data.dnssec_interface_type == "ds"
    end
  end

  describe ".get_tld_extended_attributes" do
    test "returns the extended attributes in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "GET", "/v2/tlds/com/extended_attributes", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getTldExtendedAttributes/success.http")
      end)

      {:ok, response} = @module.get_tld_extended_attributes(client, "com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 4

      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.TldExtendedAttribute end)

      [attribute | _] = data
      assert attribute.name == "uk_legal_type"
      assert attribute.description == "Legal type of registrant contact"
      assert attribute.required == false

      assert Enum.all?(attribute.options, fn single ->
               single.__struct__ == Dnsimple.TldExtendedAttribute.Option
             end)

      [option | _] = attribute.options
      assert option.title == "UK Individual"
      assert option.value == "IND"
      assert option.description == "UK Individual (our default value)"
    end
  end
end
