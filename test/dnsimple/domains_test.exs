defmodule Dnsimple.DomainsTest do
  use TestCase, async: false

  @module Dnsimple.Domains
  @account_id 1010
  @domain_id "a-domain.com"
  @push_id 6789

  setup do
    bypass = Bypass.open()

    client = %Dnsimple.Client{
      access_token: "i-am-a-token",
      base_url: "http://localhost:#{bypass.port}"
    }

    {:ok, bypass: bypass, client: client}
  end

  describe ".list_domains" do
    test "returns the domains in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listDomains/success.http")
      end)

      {:ok, response} = @module.list_domains(client, @account_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.Domain end)
    end

    test "sends custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listDomains/success.http")
      end)

      {:ok, response} =
        @module.list_domains(client, @account_id, headers: %{"X-Header" => "X-Value"})

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listDomains/success.http")
      end)

      {:ok, response} = @module.list_domains(client, @account_id, sort: "id:desc")
      assert response.__struct__ == Dnsimple.Response
    end

    test "supports filtering", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/domains", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listDomains/success.http")
      end)

      {:ok, response} =
        @module.list_domains(client, @account_id, filter: [name_like: "example"])

      assert response.__struct__ == Dnsimple.Response
    end
  end

  test ".all_domains", %{bypass: bypass, client: client} do
    page1 =
      ~s({"data":[{"id":1,"account_id":1010,"registrant_id":null,"name":"example-alpha.com","unicode_name":"example-alpha.com","token":"domain-token","state":"hosted","auto_renew":false,"private_whois":false,"expires_on":null,"created_at":"2014-12-06T15:56:55.573Z","updated_at":"2015-12-09T00:20:56.056Z"}],"pagination":{"current_page":1,"per_page":1,"total_entries":2,"total_pages":2}})

    page2 =
      ~s({"data":[{"id":2,"account_id":1010,"registrant_id":21,"name":"example-beta.com","unicode_name":"example-beta.com","token":"domain-token","state":"registered","auto_renew":false,"private_whois":false,"expires_on":"2015-12-06","created_at":"2014-12-06T15:46:52.411Z","updated_at":"2015-12-09T00:20:53.572Z"}],"pagination":{"current_page":2,"per_page":1,"total_entries":2,"total_pages":2}})

    Bypass.expect(bypass, "GET", "/v2/#{@account_id}/domains", fn conn ->
      conn = Plug.Conn.fetch_query_params(conn)
      body = if conn.query_params["page"] == "2", do: page2, else: page1

      conn
      |> Plug.Conn.put_resp_header("x-ratelimit-limit", "1000")
      |> Plug.Conn.put_resp_header("x-ratelimit-remaining", "999")
      |> Plug.Conn.put_resp_header("x-ratelimit-reset", "1450272970")
      |> Plug.Conn.resp(200, body)
    end)

    {:ok, domains} = @module.all_domains(client, @account_id)
    assert is_list(domains)
    assert length(domains) == 2
    assert Enum.all?(domains, fn single -> single.__struct__ == Dnsimple.Domain end)
  end

  describe ".get_domain" do
    test "builds the correct request", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/example-alpha.com",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "getDomain/success.http")
        end
      )

      {:ok, response} =
        @module.get_domain(client, @account_id, _domain_id = "example-alpha.com")

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Domain
      assert data.id == 181_984
      assert data.registrant_id == 2715
      assert data.name == "example-alpha.com"
      assert data.unicode_name == "example-alpha.com"
      assert data.state == "registered"
      assert data.auto_renew == false
      assert data.private_whois == false
      assert data.trustee == false
      assert data.expires_at == "2021-06-05T02:15:00Z"
      assert data.created_at == "2020-06-04T19:15:14Z"
      assert data.updated_at == "2020-06-04T19:15:21Z"
    end
  end

  describe ".create_domain" do
    test "creates the domain and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{name: "example-alpha.com"}

      Bypass.expect_once(bypass, "POST", "/v2/#{@account_id}/domains", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "createDomain/created.http")
      end)

      {:ok, response} = @module.create_domain(client, @account_id, attributes)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Domain
    end
  end

  describe ".delete_domain" do
    test "deletes the domain and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "DELETE", "/v2/#{@account_id}/domains/example.org", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "deleteDomain/success.http")
      end)

      {:ok, response} = @module.delete_domain(client, @account_id, _domain_id = "example.org")
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".enable_dnssec" do
    test "enables DNSSEC and returns a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/#{@domain_id}/dnssec",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "enableDnssec/success.http")
        end
      )

      {:ok, response} = @module.enable_dnssec(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Dnssec
      assert response.data.enabled == true
    end
  end

  describe ".disable_dnssec" do
    test "disables DNSSEC and returns nothing", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/domains/#{@domain_id}/dnssec",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "disableDnssec/success.http")
        end
      )

      {:ok, response} = @module.disable_dnssec(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".get_dnssec" do
    test "get the DNSSEC state and returns a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/dnssec",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "getDnssec/success.http")
        end
      )

      {:ok, response} = @module.get_dnssec(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Dnssec
      assert response.data.enabled == true
    end
  end

  describe ".list_delegation_signer_records" do
    test "returns the list of delegation signer records in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listDelegationSignerRecords/success.http")
        end
      )

      {:ok, response} = @module.list_delegation_signer_records(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 1

      assert Enum.all?(data, fn single ->
               single.__struct__ == Dnsimple.DelegationSignerRecord
             end)
    end

    test "sends custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listDelegationSignerRecords/success.http")
        end
      )

      {:ok, response} =
        @module.list_delegation_signer_records(client, @account_id, @domain_id,
          headers: %{"X-Header" => "X-Value"}
        )

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listDelegationSignerRecords/success.http")
        end
      )

      {:ok, response} =
        @module.list_delegation_signer_records(client, @account_id, @domain_id, sort: "id:asc")

      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".create_delegation_signer_record" do
    test "creates the delegation signer record and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{
        algorithm: "13",
        digest: "684a1f049d7d082b7f98691657da5a65764913df7f065f6f8c36edf62d66ca03",
        digest_type: "2",
        keytag: "2371"
      }

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/#{@domain_id}/ds_records",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == JSON.encode!(attributes)
          ExvcrUtils.respond_with_fixture(conn, "createDelegationSignerRecord/created.http")
        end
      )

      {:ok, response} =
        @module.create_delegation_signer_record(client, @account_id, @domain_id, attributes)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.DelegationSignerRecord
    end
  end

  describe ".get_delegation_signer_record" do
    test "returns the delegation signer record in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/ds_records/24",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "getDelegationSignerRecord/success.http")
        end
      )

      {:ok, response} =
        @module.get_delegation_signer_record(
          client,
          @account_id,
          @domain_id,
          _ds_record_id = 24
        )

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

  describe ".delete_delegation_signer_record" do
    test "deletes the delegation signer record and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/domains/example.org/ds_records/1",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "deleteDelegationSignerRecord/success.http")
        end
      )

      {:ok, response} =
        @module.delete_delegation_signer_record(
          client,
          @account_id,
          _domain_id = "example.org",
          _ds_record_id = 1
        )

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".list_email_forwards" do
    test "returns the list of email forwards in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/email_forwards",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listEmailForwards/success.http")
        end
      )

      {:ok, response} = @module.list_email_forwards(client, @account_id, @domain_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 1
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.EmailForward end)
    end

    test "sends custom headers", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/email_forwards",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listEmailForwards/success.http")
        end
      )

      {:ok, response} =
        @module.list_email_forwards(client, @account_id, @domain_id,
          headers: %{"X-Header" => "X-Value"}
        )

      assert response.__struct__ == Dnsimple.Response
    end

    test "supports sorting", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/email_forwards",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "listEmailForwards/success.http")
        end
      )

      {:ok, response} =
        @module.list_email_forwards(client, @account_id, @domain_id, sort: "to:asc")

      assert response.__struct__ == Dnsimple.Response
    end
  end

  describe ".create_email_forward" do
    test "creates the email forward and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{alias_name: "jim@a-domain.com", destination_email: "jim@another.com"}

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/#{@domain_id}/email_forwards",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == JSON.encode!(attributes)
          ExvcrUtils.respond_with_fixture(conn, "createEmailForward/created.http")
        end
      )

      {:ok, response} =
        @module.create_email_forward(client, @account_id, @domain_id, attributes)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.EmailForward
      assert data.active == true
    end
  end

  describe ".get_email_forward" do
    test "returns the email forward in a Dnsimple.Response", %{bypass: bypass, client: client} do
      Bypass.expect_once(
        bypass,
        "GET",
        "/v2/#{@account_id}/domains/#{@domain_id}/email_forwards/41872",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "getEmailForward/success.http")
        end
      )

      {:ok, response} =
        @module.get_email_forward(client, @account_id, @domain_id, _email_forward_id = 41_872)

      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.EmailForward
      assert data.id == 41_872
      assert data.domain_id == 235_146
      assert data.alias_email == "example@dnsimple.xyz"
      assert data.destination_email == "example@example.com"
      assert data.active == true
      assert data.created_at == "2021-01-25T13:54:40Z"
      assert data.updated_at == "2021-01-25T13:54:40Z"
    end
  end

  describe ".delete_email_forward" do
    test "deletes the email forward and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(
        bypass,
        "DELETE",
        "/v2/#{@account_id}/domains/example.org/email_forwards/1",
        fn conn ->
          ExvcrUtils.respond_with_fixture(conn, "deleteEmailForward/success.http")
        end
      )

      {:ok, response} =
        @module.delete_email_forward(
          client,
          @account_id,
          _domain_id = "example.org",
          _email_forward_id = 1
        )

      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".list_pushes" do
    test "returns the account's pushes in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/pushes", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "listPushes/success.http")
      end)

      {:ok, response} = @module.list_pushes(client, @account_id)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn single -> single.__struct__ == Dnsimple.Push end)
    end
  end

  describe ".initiate_push" do
    test "initiates the push and returns it in a Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{new_account_email: "other_account@example.com"}

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/#{@domain_id}/pushes",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == JSON.encode!(attributes)
          ExvcrUtils.respond_with_fixture(conn, "initiatePush/success.http")
        end
      )

      {:ok, response} = @module.initiate_push(client, @account_id, @domain_id, attributes)
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

  describe ".initiate_push with account identifier" do
    test "initiates the push using new_account_identifier", %{bypass: bypass, client: client} do
      attributes = %{new_account_identifier: "abc123"}

      Bypass.expect_once(
        bypass,
        "POST",
        "/v2/#{@account_id}/domains/#{@domain_id}/pushes",
        fn conn ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert body == JSON.encode!(attributes)
          ExvcrUtils.respond_with_fixture(conn, "initiatePush/success.http")
        end
      )

      {:ok, response} = @module.initiate_push(client, @account_id, @domain_id, attributes)
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.Push
      assert data.id == 1
      assert data.account_id == 2020
    end
  end

  describe ".accept_push" do
    test "accepts the push and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      attributes = %{contact_id: 2}

      Bypass.expect_once(bypass, "POST", "/v2/#{@account_id}/pushes/#{@push_id}", fn conn ->
        {:ok, body, conn} = Plug.Conn.read_body(conn)
        assert body == JSON.encode!(attributes)
        ExvcrUtils.respond_with_fixture(conn, "acceptPush/success.http")
      end)

      {:ok, response} = @module.accept_push(client, @account_id, @push_id, attributes)
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".reject_push" do
    test "rejects the push and returns an empty Dnsimple.Response", %{
      bypass: bypass,
      client: client
    } do
      Bypass.expect_once(bypass, "DELETE", "/v2/#{@account_id}/pushes/#{@push_id}", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "rejectPush/success.http")
      end)

      {:ok, response} = @module.reject_push(client, @account_id, @push_id)
      assert response.__struct__ == Dnsimple.Response
      assert response.data == nil
    end
  end

  describe ".get_domain_research_status" do
    test "builds the correct request", %{bypass: bypass, client: client} do
      Bypass.expect_once(bypass, "GET", "/v2/#{@account_id}/domains/research/status", fn conn ->
        ExvcrUtils.respond_with_fixture(conn, "getDomainsResearchStatus/success-unavailable.http")
      end)

      {:ok, response} = @module.get_domain_research_status(client, @account_id, "taken.com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert data.__struct__ == Dnsimple.DomainResearchStatus
      assert data.request_id == "25dd77cb-2f71-48b9-b6be-1dacd2881418"
      assert data.domain == "taken.com"
      assert data.availability == "unavailable"
      assert data.errors == []
    end
  end
end
