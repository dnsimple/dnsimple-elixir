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
      {:ok, url: url, fixture: "listDomains/success.http", method: "get"}
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
    test "builds the correct request" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/example-alpha.com"
      method  = "get"
      fixture = "getDomain/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain(@client, @account_id, _domain_id = "example-alpha.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Domain
        assert data.id == 181984
        assert data.registrant_id == 2715
        assert data.name == "example-alpha.com"
        assert data.unicode_name == "example-alpha.com"
        assert data.state == "registered"
        assert data.auto_renew == false
        assert data.private_whois == false
        assert data.expires_at == "2021-06-05T02:15:00Z"
        assert data.created_at == "2020-06-04T19:15:14Z"
        assert data.updated_at == "2020-06-04T19:15:21Z"
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


  describe ".enable_dnssec" do
    test "enables DNSSEC and returns a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/dnssec"
      method     = "post"
      fixture    = "enableDnssec/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.enable_dnssec(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
        assert response.data.__struct__ == Dnsimple.Dnssec
        assert response.data.enabled == true
      end
    end
  end


  describe ".disable_dnssec" do
    test "disables DNSSEC and returns nothing" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/dnssec"
      method  = "delete"
      fixture = "disableDnssec/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.disable_dnssec(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end


  describe ".get_dnssec" do
    test "get the DNSSEC state and returns a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/dnssec"
      method  = "get"
      fixture = "getDnssec/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.get_dnssec(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
        assert response.data.__struct__ == Dnsimple.Dnssec
        assert response.data.enabled == true
      end
    end
  end


  describe ".list_delegation_signer_records" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/ds_records"
      {:ok, fixture: "listDelegationSignerRecords/success.http", method: "get", url: url}
    end

    test "returns the list of delegation signer records in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_delegation_signer_records(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 1
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.DelegationSignerRecord end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_delegation_signer_records(@client, @account_id, @domain_id, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/ds_records?sort=id%3Aasc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_delegation_signer_records(@client, @account_id, @domain_id, sort: "id:asc")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".create_delegation_signer_record" do
    test "creates the delegation signer record and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/ds_records"
      method     = "post"
      fixture    = "createDelegationSignerRecord/created.http"
      attributes = %{algorithm: "13", digest: "684a1f049d7d082b7f98691657da5a65764913df7f065f6f8c36edf62d66ca03", digest_type: "2", keytag: "2371"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_delegation_signer_record(@client, @account_id, @domain_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DelegationSignerRecord
      end
    end
  end


  describe ".get_delegation_signer_record" do
    test "returns the delegation signer record in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/ds_records/24"
      method  = "get"
      fixture = "getDelegationSignerRecord/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_delegation_signer_record(@client, @account_id, @domain_id, _ds_record_id = 24)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DelegationSignerRecord
        assert data.id == 24
        assert data.domain_id == 1010
        assert data.algorithm == "8"
        assert data.digest == "C1F6E04A5A61FBF65BF9DC8294C363CF11C89E802D926BDAB79C55D27BEFA94F"
        assert data.digest_type == "2"
        assert data.keytag == "44620"
        assert data.created_at == "2017-03-03T13:49:58Z"
        assert data.updated_at == "2017-03-03T13:49:58Z"
      end
    end
  end


  describe ".delete_delegation_signer_record" do
    test "deletes the delegation signer record and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/example.org/ds_records/1"
      method  = "delete"
      fixture = "deleteDelegationSignerRecord/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.delete_delegation_signer_record(@client, @account_id, _domain_id = "example.org", _ds_record_id = 1)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
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
        assert length(data) == 1
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
  end


  describe ".create_email_forward" do
    test "creates the email forward and returns it in a Dnsimple.Response" do
      url        = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/email_forwards"
      method     = "post"
      fixture    = "createEmailForward/created.http"
      attributes = %{alias_name: "jim@a-domain.com", destination_email: "jim@another.com"}
      body       = Poison.encode!(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.create_email_forward(@client, @account_id, @domain_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.EmailForward
        assert data.active == true
      end
    end
  end


  describe ".get_email_forward" do
    test "returns the email forward in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/41872"
      method  = "get"
      fixture = "getEmailForward/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_email_forward(@client, @account_id, @domain_id, _email_forward_id = 41872)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.EmailForward
        assert data.id == 41872
        assert data.domain_id == 235146
        assert data.from == "example@dnsimple.xyz"
        assert data.to == "example@example.com"
        assert data.alias_email == "example@dnsimple.xyz"
        assert data.destination_email == "example@example.com"
        assert data.active == true
        assert data.created_at == "2021-01-25T13:54:40Z"
        assert data.updated_at == "2021-01-25T13:54:40Z"
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
    test "returns the account's pushes in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/pushes"
      method  = "get"
      fixture = "listPushes/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_pushes(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Push end)
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


end
