defmodule Dnsimple.TemplatesTest do
  use TestCase, async: false

  @module Dnsimple.Templates
  @account_id 1010

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_templates" do
    test "returns the templates in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTemplates/success.http")
      end)

      {:ok, response} = @module.list_templates(client, @account_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert length(data) == 2
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.Template end)
    end

    test "supports custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTemplates/success.http")
      end)

      {:ok, response} =
        @module.list_templates(client, @account_id, headers: %{"X-Header" => "X-Value"})

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTemplates/success.http")
      end)

      {:ok, response} = @module.list_templates(client, @account_id, sort: "name:desc")
      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_template" do
    test "returns the template in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getTemplate/success.http")
      end)

      {:ok, response} = @module.get_template(client, @account_id, _template_id = 1)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Template
      assert data.id == 1
      assert data.sid == "alpha"
      assert data.account_id == @account_id
      assert data.name == "Alpha"
      assert data.description == "An alpha template."
      assert data.created_at == "2016-03-22T11:08:58Z"
      assert data.updated_at == "2016-03-22T11:08:58Z"
    end
  end

  describe ".create_template" do
    test "creates the template and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{sid: "beta", name: "Beta", description: "A beta template."}

      Bypass.expect_once(bypass, "POST", "/v2/#{@account_id}/templates", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "createTemplate/created.http")
      end)

      {:ok, response} = @module.create_template(client, @account_id, attributes)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Template
    end
  end

  describe ".update_template" do
    test "updates the template and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{sid: "alpha", name: "Alpha", description: "An alpha template."}

      Bypass.expect_once(bypass, "PATCH", "/v2/#{@account_id}/templates/beta", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "updateTemplate/success.http")
      end)

      {:ok, response} =
        @module.update_template(client, @account_id, _template_id = "beta", attributes)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Template
      assert data.sid == "alpha"
      assert data.name == "Alpha"
      assert data.description == "An alpha template."
    end
  end

  describe ".delete_template" do
    test "deletes the template and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "DELETE", "/v2/#{@account_id}/templates/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "deleteTemplate/success.http")
      end)

      {:ok, response} = @module.delete_template(client, @account_id, _template_id = 1)
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".list_template_records" do
    test "returns the records in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates/1/records", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTemplateRecords/success.http")
      end)

      {:ok, response} = @module.list_template_records(client, @account_id, _template_id = 1)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert length(data) == 2
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.TemplateRecord end)
    end

    test "supports custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates/1/records", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTemplateRecords/success.http")
      end)

      {:ok, response} =
        @module.list_template_records(client, @account_id, _template_id = 1,
          headers: %{"X-Header" => "X-Value"}
        )

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates/1/records", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listTemplateRecords/success.http")
      end)

      {:ok, response} =
        @module.list_template_records(client, @account_id, _template_id = 1, sort: "type:desc")

      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_template_record" do
    test "returns the record in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/templates/268/records/301", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getTemplateRecord/success.http")
      end)

      {:ok, response} =
        @module.get_template_record(client, @account_id, template_id = 268, record_id = 301)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.TemplateRecord
      assert data.id == record_id
      assert data.template_id == template_id
      assert data.type == "MX"
      assert data.name == ""
      assert data.content == "mx.example.com"
      assert data.ttl == 600
      assert data.priority == 10
      assert data.created_at == "2016-05-03T08:03:26Z"
      assert data.updated_at == "2016-05-03T08:03:26Z"
    end
  end

  describe ".create_template_record" do
    test "creates the record and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{name: "", type: "mx", content: "mx.example.com", ttl: 600, priority: 10}

      Bypass.expect_once(bypass, "POST", "/v2/#{@account_id}/templates/268/records", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "createTemplateRecord/created.http")
      end)

      {:ok, response} =
        @module.create_template_record(client, @account_id, _template_id = 268, attributes)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.TemplateRecord
    end
  end

  describe ".delete_template_record" do
    test "deletes the record and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/templates/268/records/301",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "deleteTemplateRecord/success.http")
        end
      )

      {:ok, response} =
        @module.delete_template_record(
          client,
          @account_id,
          _template_id = 268,
          _record_id = 301
        )

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".apply_template" do
    test "applies the template to the domain and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/example.com/templates/1",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "applyTemplate/success.http")
        end
      )

      {:ok, response} =
        @module.apply_template(
          client,
          @account_id,
          _domain_id = "example.com",
          _template_id = 1
        )

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end
end
