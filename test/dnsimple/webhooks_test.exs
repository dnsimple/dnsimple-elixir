defmodule Dnsimple.WebhooksTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Webhooks
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  describe ".list_webhooks" do
    test "returns the list of webhooks in a Dnsimple.Response" do
      url = "#{@client.base_url}/v2/1010/webhooks"

      use_cassette :stub, ExvcrUtils.response_fixture("listWebhooks/success.http", method: "get", url: url) do
        {:ok, response} = @module.list_webhooks(@client, "1010")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(webhook) -> webhook.__struct__ == Dnsimple.Webhook end)
        assert Enum.all?(data, fn(webhook) -> is_integer(webhook.id) end)
      end
    end

    test "sends custom headers" do
      url = "#{@client.base_url}/v2/1010/webhooks"

      use_cassette :stub, ExvcrUtils.response_fixture("listWebhooks/success.http", method: "get", url: url) do
        @module.list_webhooks(@client, "1010", [headers: %{"X-Header" => "X-Value"}])
      end
    end

    test "can be called using the alias .webhooks" do
      url = "#{@client.base_url}/v2/1010/webhooks"

      use_cassette :stub, ExvcrUtils.response_fixture("listWebhooks/success.http", method: "get", url: url) do
        {:ok, response} = @module.webhooks(@client, "1010")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  test ".create_webhook builds the correct request" do
    fixture = ExvcrUtils.response_fixture("createWebhook/created.http", [method: "post", url: @client.base_url <> "/v2/1010/webhooks", request_body: ~s'{"url":"https://webhook.test"}'])
    use_cassette :stub, fixture do
      @module.create_webhook(@client, "1010", %{url: "https://webhook.test"})
    end
  end

  test ".create_webhooks returns a Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("createWebhook/created.http", [method: "post", request_body: ""])
    use_cassette :stub, fixture do
      {:ok, response} = @module.create_webhook(@client, "1010", "")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_map(data)
      assert data.__struct__ == Dnsimple.Webhook
      assert data.id == 1
      assert data.url == "https://webhook.test"
    end
  end


  test ".webhook builds the correct request" do
    fixture = ExvcrUtils.response_fixture("getWebhook/success.http", [method: "get", url: @client.base_url <> "/v2/1010/webhooks/1"])
    use_cassette :stub, fixture do
      @module.webhook(@client, "1010", "1")
    end
  end

  test ".webhook returns a Dnsimple.Response" do
    use_cassette :stub, ExvcrUtils.response_fixture("getWebhook/success.http", [method: "get"]) do
      {:ok, response} = @module.webhook(@client, "1010", "1")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_map(data)
      assert data.__struct__ == Dnsimple.Webhook
      assert data.id == 1
      assert data.url == "https://webhook.test"
    end
  end


  test ".delete_webhook builds the correct request" do
    fixture = ExvcrUtils.response_fixture("deleteWebhook/success.http", [method: "delete", url: @client.base_url <> "/v2/1010/webhooks/1"])
    use_cassette :stub, fixture do
      @module.delete_webhook(@client, "1010", "1")
    end
  end

  test ".delete_webhook returns a Dnsimple.Response" do
    use_cassette :stub, ExvcrUtils.response_fixture("deleteWebhook/success.http", [method: "delete"]) do
      {:ok, response} = @module.delete_webhook(@client, "1010", "1")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_nil(data)
    end
  end
end
