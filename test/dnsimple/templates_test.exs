defmodule Dnsimple.TemplatesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Templates
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  describe ".list_templates" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/templates"
      {:ok, fixture: "listTemplates/success.http", method: "get", url: url}
    end

    test "returns the templates in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.list_templates(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Template end)
      end
    end

    test "supports custom headers", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_templates(@client, @account_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture_file, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/templates?sort=name%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_templates(@client, @account_id, sort: "name:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "it can be called using the alias .templates", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.templates(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_template" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/templates/1"
      {:ok, fixture: "getTemplate/success.http", method: "get", url: url}
    end

    test "returns the template in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.get_template(@client, @account_id, _template_id = 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Template
        assert data.id == 1
        assert data.account_id == @account_id
        assert data.name == "Alpha"
        assert data.short_name == "alpha"
        assert data.description == "An alpha template."
        assert data.created_at == "2016-03-22T11:08:58.262Z"
        assert data.updated_at == "2016-03-22T11:08:58.262Z"
      end
    end

    test "it can be called using the alias .templates", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/templates/alpha"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.template(@client, @account_id, _template_id = "alpha")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_template" do
    test "creates the template and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/templates"
      method     = "post"
      fixture    = "createTemplate/created.http"
      attributes = %{name: "Beta", short_name: "beta", description: "A beta template."}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = @module.create_template(@client, @account_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Template
      end
    end
  end


  describe ".update_template" do
    test "updates the template and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/templates/beta"
      method     = "patch"
      fixture    = "updateTemplate/success.http"
      attributes = %{name: "Alpha", short_name: "alpha", description: "An alpha template."}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = @module.update_template(@client, @account_id, _template_id = "beta", attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Template
        assert data.name == "Alpha"
        assert data.short_name == "alpha"
        assert data.description == "An alpha template."
      end
    end
  end


end
