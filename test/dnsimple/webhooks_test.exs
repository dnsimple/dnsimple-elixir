defmodule Dnsimple.WebhooksTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Webhooks
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  describe ".list_webhooks" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/webhooks"
      {:ok, fixture: "listWebhooks/success.http", method: "get", url: url}
    end

    test "returns the list of webhooks in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture,  method: method, url: url) do
        {:ok, response} = @module.list_webhooks(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(webhook) -> webhook.__struct__ == Dnsimple.Webhook end)
      end
    end

    test "can send custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_webhooks(@client, @account_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .webhooks", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.webhooks(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_webhook" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/webhooks/1"
      {:ok, fixture: ExvcrUtils.response_fixture("getWebhook/success.http", method: "get", url: url)}
    end

    test "returns the webhook in a Dnsimple.Response", %{fixture: fixture} do
      use_cassette :stub, fixture do
        {:ok, response} = @module.get_webhook(@client, @account_id, _webhook_id = 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Webhook
        assert data.id == 1
        assert data.url == "https://webhook.test"
      end
    end

    test "can be called using the alias .webhook", %{fixture: fixture} do
      use_cassette :stub, fixture do
        {:ok, response} = @module.webhook(@client, @account_id, _webhook_id = 1)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_webhook" do
    test "creates the webhook and returns it in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/webhooks"
      method  = "post"
      fixture = "createWebhook/created.http"
      body    = ~s'{"url":"https://webhook.test"}'

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_webhook(@client, @account_id, %{url: "https://webhook.test"})
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_map(data)
        assert data.__struct__ == Dnsimple.Webhook
        assert data.id == 1
        assert data.url == "https://webhook.test"
      end
    end
  end


  describe ".delete_webhook" do
    test "deletes the webhook and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/webhooks/1"
      method  = "delete"
      fixture = "deleteWebhook/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_webhook(@client, @account_id, _webhook_id = 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data == nil
      end
    end
  end

end
