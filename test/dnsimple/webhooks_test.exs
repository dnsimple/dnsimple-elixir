defmodule Dnsimple.WebhooksServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.Webhooks
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".webhooks builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listWebhooks/success.http", [method: "get", url: @client.base_url <> "/v2/1010/webhooks"])
    use_cassette :stub, fixture do
      @service.webhooks(@client, "1010")
    end
  end

  test ".webhooks builds sends custom headers" do
    fixture = ExvcrUtils.response_fixture("listWebhooks/success.http", [method: "get", url: @client.base_url <> "/v2/1010/webhooks"])
    use_cassette :stub, fixture do
      @service.webhooks(@client, "1010", [headers: %{"X-Header" => "X-Value"}])
    end
  end

  test ".webhooks returns a list of Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("listWebhooks/success.http", [method: "get"])
    use_cassette :stub, fixture do
      { :ok, response } = @service.webhooks(@client, "1010")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Webhook end)
      assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
    end
  end


  test ".create_webhook builds the correct request" do
    fixture = ExvcrUtils.response_fixture("createWebhook/created.http", [method: "post", url: @client.base_url <> "/v2/1010/webhooks", request_body: ~s'{"url":"https://webhook.test"}'])
    use_cassette :stub, fixture do
      @service.create_webhook(@client, "1010", %{ url: "https://webhook.test" })
    end
  end

  test ".create_webhooks returns a Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("createWebhook/created.http", [method: "post", request_body: ""])
    use_cassette :stub, fixture do
      { :ok, response } = @service.create_webhook(@client, "1010", "")
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
      @service.webhook(@client, "1010", "1")
    end
  end

  test ".webhook returns a Dnsimple.Response" do
    use_cassette :stub, ExvcrUtils.response_fixture("getWebhook/success.http", [method: "get"]) do
      { :ok, response } = @service.webhook(@client, "1010", "1")
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
      @service.delete_webhook(@client, "1010", "1")
    end
  end

  test ".delete_webhook returns a Dnsimple.Response" do
    use_cassette :stub, ExvcrUtils.response_fixture("deleteWebhook/success.http", [method: "delete"]) do
      { :ok, response } = @service.delete_webhook(@client, "1010", "1")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_nil(data)
    end
  end
end
