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
        assert data.sid == "alpha"
        assert data.account_id == @account_id
        assert data.name == "Alpha"
        assert data.description == "An alpha template."
        assert data.created_at == "2016-03-22T11:08:58Z"
        assert data.updated_at == "2016-03-22T11:08:58Z"
      end
    end

    test "it can be called using the alias .template", %{fixture: fixture, method: method} do
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
      attributes = %{sid: "beta", name: "Beta", description: "A beta template."}
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
      attributes = %{sid: "alpha", name: "Alpha", description: "An alpha template."}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = @module.update_template(@client, @account_id, _template_id = "beta", attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Template
        assert data.sid == "alpha"
        assert data.name == "Alpha"
        assert data.description == "An alpha template."
      end
    end
  end


  describe ".delete_template" do
    test "deletes the template and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/templates/1"
      method     = "delete"
      fixture    = "deleteTemplate/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.delete_template(@client, @account_id, _template_id = 1)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".list_template_records" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/templates/1/records"
      {:ok, fixture: "listTemplateRecords/success.http", method: "get", url: url}
    end

    test "returns the records in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.list_template_records(@client, @account_id, _template_id = 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.TemplateRecord end)
      end
    end

    test "supports custom headers", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_template_records(@client, @account_id, _template_id = 1, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture_file, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/templates/1/records?sort=type%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_template_records(@client, @account_id, _template_id = 1, sort: "type:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "it can be called using the alias .template_records", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.template_records(@client, @account_id, _template_id = 1)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_template_record" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/templates/268/records/301"
      {:ok, fixture: "getTemplateRecord/success.http", method: "get", url: url}
    end

    test "returns the record in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.get_template_record(@client, @account_id, template_id = 268, record_id = 301)
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

    test "it can be called using the alias .template_record", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.template_record(@client, @account_id, _template_id = 268, _record_id = 301)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_template_record" do
    test "creates the record and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/templates/268/records"
      method     = "post"
      fixture    = "createTemplateRecord/created.http"
      attributes = %{name: "", type: "mx", content: "mx.example.com", ttl: 600, priority: 10}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = @module.create_template_record(@client, @account_id, _template_id = 268, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.TemplateRecord
      end
    end
  end


  describe ".delete_template_record" do
    test "deletes the record and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/templates/268/records/301"
      method     = "delete"
      fixture    = "deleteTemplateRecord/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.delete_template_record(@client, @account_id, _template_id = 268, _record_id = 301)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".apply_template" do
    test "applies the template to the domain and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/example.com/templates/1"
      method     = "post"
      fixture    = "applyTemplate/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.apply_template(@client, @account_id, _domain_id = "example.com", _template_id = 1)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end

end
