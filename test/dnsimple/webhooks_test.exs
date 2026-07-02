defmodule Dnsimple.WebhooksTest do
  use TestCase, async: false

  @module Dnsimple.Webhooks
  @account_id 1010

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_webhooks" do
    test "returns the list of webhooks in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/webhooks", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listWebhooks/success.http")
      end)

      {:ok, response} = @module.list_webhooks(client, @account_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn webhook -> webhook.__struct__ == Dnsimple.Webhook end)
    end

    test "can send custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/webhooks", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listWebhooks/success.http")
      end)

      {:ok, response} =
        @module.list_webhooks(client, @account_id, headers: %{"X-Header" => "X-Value"})

      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".get_webhook" do
    test "returns the webhook in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/webhooks/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getWebhook/success.http")
      end)

      {:ok, response} = @module.get_webhook(client, @account_id, _webhook_id = 1)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Webhook
      assert data.id == 1
      assert data.url == "https://webhook.test"
    end
  end

  describe ".create_webhook" do
    test "creates the webhook and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      body = ~s'{"url":"https://webhook.test"}'

      Bypass.expect_once(bypass, "POST", "/v2/#{@account_id}/webhooks", fn conn ->
        {:ok, request_body, conn} = Plug.Conn.read_body(conn)
        assert request_body == body
        ExvcrUtils.respond_with_fixture(conn, "createWebhook/created.http")
      end)

      {:ok, response} =
        @module.create_webhook(client, @account_id, %{url: "https://webhook.test"})

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_map(data)
      assert data.__struct__ == Dnsimple.Webhook
      assert data.id == 1
      assert data.url == "https://webhook.test"
    end
  end

  describe ".delete_webhook" do
    test "deletes the webhook and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "DELETE", "/v2/#{@account_id}/webhooks/1", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "deleteWebhook/success.http")
      end)

      {:ok, response} = @module.delete_webhook(client, @account_id, _webhook_id = 1)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data == nil
    end
  end
end
