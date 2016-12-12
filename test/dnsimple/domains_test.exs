defmodule Dnsimple.DomainsTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Domains
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010

  setup do
    ExVCR.Config.cassette_library_dir("test/fixtures/vcr_cassettes", "test/fixtures/custom_cassettes")
    :ok
  end

  describe ".list_domains" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains"
      {:ok, fixture: "listDomains/success.http", method: "get", url: url}
    end

    test "returns the domains in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/domains?sort=id%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id, sort: "id:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/domains?name_like=example"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_domains(@client, @account_id, filter: [name_like: "example"])
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .domains", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.domains(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  test ".all_domains" do
    use_cassette "list_domains_paginated", custom: true do
      {:ok, domains} = @module.all_domains(@client, @account_id)
      assert is_list(domains)
      assert length(domains) == 2
      assert Enum.all?(domains, fn(single) -> single.__struct__ == Dnsimple.Domain end)
    end
  end


  describe ".get_domain" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/example-alpha.com"
      {:ok, fixture: "getDomain/success.http", method: "get", url: url}
    end

    test "builds the correct request", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.domain(@client, @account_id, _domain_id = "example-alpha.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Domain
        assert data.id == 1
        assert data.name == "example-alpha.com"
      end
    end

    test "can be called using the alias .domain", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain(@client, @account_id, "example-alpha.com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_domain" do
    test "creates the domain and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains"
      method     = "post"
      fixture    = "createDomain/created.http"
      attributes = %{name: "example-alpha.com"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_domain(@client, @account_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Domain
      end
    end
  end


  describe ".delete_domain" do
    test "deletes the domain and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/example.org"
      method  = "delete"
      fixture = "deleteDomain/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_domain(@client, @account_id, _domain_id = "example.org")
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  @domain_id "a-domain.com"


  describe "reset_domain_token" do
    test "returns a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/token"
      method      = "post"
      fixture     = "resetDomainToken/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.reset_domain_token(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
        assert response.data.__struct__ == Dnsimple.Domain
      end
    end
  end


  describe ".list_email_forwards" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/email_forwards"
      {:ok, fixture: "listEmailForwards/success.http", method: "get", url: url}
    end

    test "returns the list of email forwards in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_email_forwards(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.EmailForward end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_email_forwards(@client, @account_id, @domain_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/email_forwards?sort=to%3Aasc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_email_forwards(@client, @account_id, @domain_id, sort: "to:asc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .email_forwards", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.email_forwards(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_email_forward" do
    test "creates the email forward and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/email_forwards"
      method     = "post"
      fixture    = "createEmailForward/created.http"
      attributes = %{from: "jim@a-domain.com", to: "jim@another.com"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_email_forward(@client, @account_id, @domain_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.EmailForward
      end
    end
  end


  describe ".get_email_forward" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/17706"
      {:ok, fixture: "getEmailForward/success.http", method: "get", url: url}
    end

    test "returns the email forward in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_email_forward(@client, @account_id, @domain_id, _email_forward_id = 17706)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.EmailForward
        assert data.id == 17706
        assert data.domain_id == 228963
        assert data.from == "jim@a-domain.com"
        assert data.to == "jim@another.com"
        assert data.created_at == "2016-02-04T14:26:50Z"
        assert data.updated_at == "2016-02-04T14:26:50Z"
      end
    end

    test "can be called using the alias .email_forward", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.email_forward(@client, @account_id, @domain_id, _email_forward_id = 17706)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".delete_email_forward" do
    test "deletes the email forward and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/example.org/email_forwards/1"
      method  = "delete"
      fixture = "deleteEmailForward/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_email_forward(@client, @account_id, _domain_id = "example.org", _email_forward_id = 1)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".list_pushes" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/pushes"
      {:ok, fixture: "listPushes/success.http", method: "get", url: url}
    end

    test "returns the account's pushes in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_pushes(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Push end)
      end
    end

    test "can be called using the alias .pushes", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.pushes(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".initiate_push" do
    test "initiates the push and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/pushes"
      method     = "post"
      fixture    = "initiatePush/success.http"
      attributes = %{new_account_email: "other_account@example.com"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.initiate_push(@client, @account_id, @domain_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Push
        assert data.id == 1
        assert data.domain_id == 100
        assert data.contact_id == nil
        assert data.account_id == 2020
        assert data.accepted_at == nil
        assert data.created_at == "2016-08-11T10:16:03Z"
        assert data.updated_at == "2016-08-11T10:16:03Z"
      end
    end
  end


  @push_id 6789


  describe ".accept_push" do
    test "accepts the push and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/pushes/#{@push_id}"
      method     = "post"
      fixture    = "acceptPush/success.http"
      attributes = %{contact_id: 2}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.accept_push(@client, @account_id, @push_id, attributes)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".reject_push" do
    test "rejects the push and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/pushes/#{@push_id}"
      method     = "delete"
      fixture    = "rejectPush/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.reject_push(@client, @account_id, @push_id)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".list_collaborators" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/collaborators"
      {:ok, fixture: "listCollaborators/success.http", method: "get", url: url}
    end

    test "returns the collaborators in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_collaborators(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Collaborator end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_collaborators(@client, @account_id, @domain_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .collaborators", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.collaborators(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".add_collaborator" do
    test "adds the collaborator and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/collaborators"
      method     = "post"
      fixture    = "addCollaborator/success.http"
      attributes = %{email: "existing-user@example.com"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.add_collaborator(@client, @account_id, @domain_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Collaborator
        assert data.id == 100
        assert data.domain_id == 1
        assert data.domain_name == "example.com"
        assert data.user_id == 999
        assert data.user_email == "existing-user@example.com"
        assert data.accepted_at == "2016-10-07T08:53:41Z"
        assert data.created_at == "2016-10-07T08:53:41Z"
        assert data.updated_at == "2016-10-07T08:53:41Z"
      end
    end
  end


  describe ".remove_collaborator" do
    test "removes the collaborator and returns an empty Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/collaborators/100"
      method     = "delete"
      fixture    = "removeCollaborator/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.remove_collaborator(@client, @account_id, @domain_id, _collaborator_id = 100)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end

end
