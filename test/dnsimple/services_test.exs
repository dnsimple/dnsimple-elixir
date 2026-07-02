defmodule Dnsimple.ServicesTest do
  use TestCase, async: false

  @module Dnsimple.Services
  @account_id 1010
  @domain_id "example.com"

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_services" do
    test "returns the services in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/services", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listServices/success.http")
      end)

      {:ok, response} = @module.list_services(client)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.Service end)
    end

    test "correctly parses the service's Settings", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/services", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listServices/success.http")
      end)

      {:ok, response} = @module.list_services(client)

      [_, service] = response.data
      settings = service.settings
      assert is_list(settings)
      assert Enum.all?(settings, fn single -> single.__struct__ == Dnsimple.Service.Setting end)
    end

    test "sends custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/services", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listServices/success.http")
      end)

      {:ok, response} = @module.list_services(client)
      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/services", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listServices/success.http")
      end)

      {:ok, response} = @module.list_services(client, sort: "short_name:desc")
      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_service" do
    test "returns the service in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/services/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getService/success.http")
      end)

      {:ok, response} = @module.get_service(client, _service_id = 1)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Service
      assert data.id == 1
      assert data.sid == "service1"
      assert data.name == "Service 1"
      assert data.description == "First service example."
      assert data.setup_description == nil
      assert data.requires_setup == true
      assert data.default_subdomain == nil

      assert data.settings == [
               %Dnsimple.Service.Setting{
                 append: ".service1.com",
                 description:
                   "Your Service 1 username is used to connect services to your account.",
                 example: "username",
                 label: "Service 1 Account Username",
                 name: "username",
                 password: false
               }
             ]

      assert data.created_at == "2014-02-14T19:15:19Z"
      assert data.updated_at == "2016-03-04T09:23:27Z"
    end
  end

  describe ".applied_services" do
    test "returns applied services in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/services",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "appliedServices/success.http")
        end
      )

      {:ok, response} = @module.applied_services(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 1
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.Service end)
    end

    test "correctly parses the applied service's Settings", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/services",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "appliedServices/success.http")
        end
      )

      {:ok, response} = @module.applied_services(client, @account_id, @domain_id)

      [service | _] = response.data
      settings = service.settings
      assert is_list(settings)
      assert Enum.all?(settings, fn single -> single.__struct__ == Dnsimple.Service.Setting end)
    end

    test "sends custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/services",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "appliedServices/success.http")
        end
      )

      {:ok, response} = @module.applied_services(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".apply_service" do
    test "applies the service and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      settings = %{settings: %{name: "value"}}

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/#{@domain_id}/services/1",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == JSON.encode!(settings)
          ExvcrUtils.respond_with_fixture(conn, "applyService/success.http")
        end
      )

      {:ok, response} =
        @module.apply_service(client, @account_id, @domain_id, _service_id = 1, settings)

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".unapply_service" do
    test "un-applies the service and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/domains/#{@domain_id}/services/1",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "applyService/success.http")
        end
      )

      {:ok, response} =
        @module.unapply_service(client, @account_id, @domain_id, _service_id = 1)

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end
end
