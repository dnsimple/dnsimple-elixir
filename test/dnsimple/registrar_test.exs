defmodule Dnsimple.RegistrarTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Registrar
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010
  @domain_id "example.com"

  describe ".check_domain" do
    test "returns the domain check in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/ruby.codes/check"
      method  = "get"
      fixture = "checkDomain/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.check_domain(@client, @account_id, "ruby.codes")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainCheck
        assert data.domain == "ruby.codes"
        assert data.available == true
        assert data.premium == true
      end
    end
  end


  describe ".get_domain_premium_price" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/premium.com/premium_price"
      {:ok, method: "get", url: url}
    end

    test "returns the result in a Dnsimple.Response for a premium domain", %{method: method, url: url} do
      fixture = "getDomainPremiumPrice/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain_premium_price(@client, @account_id, "premium.com", %{action: "registration"})
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainPremiumPrice
        assert data.premium_price == "109.00"
        assert data.action == "registration"
      end
    end

    test "returns the result in a Dnsimple.Response for a domain that is not premium", %{method: method, url: url} do
      fixture = "getDomainPremiumPrice/failure.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:error, response} = @module.get_domain_premium_price(@client, @account_id, "premium.com")
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 400: `example.com` is not a premium domain for registration"
      end
    end
  end

  describe ".get_domain_prices" do
    test "returns the result in a Dnsimple.Response for the domain" do
      url = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/bingo.pizza/prices"
      fixture = "getDomainPrices/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: "get", url: url) do
        {:ok, response} = @module.get_domain_prices(@client, @account_id, "bingo.pizza")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainPrice
        assert data.domain == "bingo.pizza"
        assert data.premium == true
        assert data.registration_price == 20.0
        assert data.renewal_price == 20.0
        assert data.transfer_price == 20.0
      end
    end

    test "returns the error result in a Dnsimple.Response for a not supported TLD" do
      url = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/bingo.pineapple/prices"
      fixture = "getDomainPrices/failure.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: "get", url: url) do
        {:error, response} = @module.get_domain_prices(@client, @account_id, "bingo.pineapple")
        assert response.__struct__ == Dnsimple.RequestError
        assert response.message == "HTTP 400: TLD .PINEAPPLE is not supported"
      end
    end
  end

  describe ".register_domain" do
    test "returns the registered domain in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/registrations"
      method      = "post"
      fixture     = "registerDomain/success.http"
      attributes  = %{registrant_id: 2, auto_renew: false, whois_privacy: false}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.register_domain(@client, @account_id, "example.com", attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainRegistration
        assert data.id == 1
        assert data.domain_id == 999
        assert data.registrant_id == 2
        assert data.period == 1
        assert data.state == "new"
        assert data.auto_renew == false
        assert data.whois_privacy == false
        assert data.created_at == "2016-12-09T19:35:31Z"
        assert data.updated_at == "2016-12-09T19:35:31Z"
      end
    end
  end

  describe ".get_domain_registration" do
    test "returns the domain registration in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/registrations/1"
      method      = "get"
      fixture     = "getDomainRegistration/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain_registration(@client, @account_id, "example.com", 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainRegistration
        assert data.id == 361
        assert data.domain_id == 104040
        assert data.registrant_id == 2715
        assert data.period == 1
        assert data.state == "registering"
        assert data.auto_renew == false
        assert data.whois_privacy == false
        assert data.created_at == "2023-01-27T17:44:32Z"
        assert data.updated_at == "2023-01-27T17:44:40Z"
      end
    end
  end


  describe ".renew_domain" do
    test "returns the renewed domain in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/renewals"
      method      = "post"
      fixture     = "renewDomain/success.http"
      attributes  = %{period: 3}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.renew_domain(@client, @account_id, "example.com", attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainRenewal
        assert data.id == 1
        assert data.domain_id == 999
        assert data.period == 1
        assert data.state == "new"
        assert data.created_at == "2016-12-09T19:46:45Z"
        assert data.updated_at == "2016-12-09T19:46:45Z"
      end
    end
  end

  describe ".get_domain_renewal" do
    test "returns the domain renewal in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/renewals/1"
      method      = "get"
      fixture     = "getDomainRenewal/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain_renewal(@client, @account_id, "example.com", 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainRenewal
        assert data.id == 1
        assert data.domain_id == 999
        assert data.period == 1
        assert data.state == "renewed"
        assert data.created_at == "2016-12-09T19:46:45Z"
        assert data.updated_at == "2016-12-12T19:46:45Z"
      end
    end
  end


  describe ".transfer_domain" do
    test "returns the domain to be transferred in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/transfers"
      method      = "post"
      fixture     = "transferDomain/success.http"
      attributes  = %{registrant_id: 10, auth_code: "x1y2z3", auto_renew: false, whois_privacy: false}
      {:ok, body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
        {:ok, response} = @module.transfer_domain(@client, @account_id, "example.com", attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainTransfer
        assert data.id == 1
        assert data.domain_id == 999
        assert data.registrant_id == 2
        assert data.state == "transferring"
        assert data.auto_renew == false
        assert data.whois_privacy == false
        assert data.created_at == "2016-12-09T19:43:41Z"
        assert data.updated_at == "2016-12-09T19:43:43Z"
      end
    end
  end

  describe ".get_domain_transfer" do
    test "returns the domain transfer in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/transfers/361"
      method      = "get"
      fixture     = "getDomainTransfer/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain_transfer(@client, @account_id, "example.com", 361)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainTransfer
        assert data.id == 361
        assert data.domain_id == 182245
        assert data.registrant_id == 2715
        assert data.state == "cancelled"
        assert data.auto_renew == false
        assert data.whois_privacy == false
        assert data.status_description == "Canceled by customer"
        assert data.created_at == "2020-06-05T18:08:00Z"
        assert data.updated_at == "2020-06-05T18:10:01Z"
      end
    end
  end

  describe ".cancel_domain_transfer" do
    test "returns the domain transfer in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/transfers/361"
      method      = "delete"
      fixture     = "cancelDomainTransfer/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.cancel_domain_transfer(@client, @account_id, "example.com", 361)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.DomainTransfer
        assert data.id == 361
        assert data.domain_id == 182245
        assert data.registrant_id == 2715
        assert data.state == "transferring"
        assert data.auto_renew == false
        assert data.whois_privacy == false
        assert data.status_description == nil
        assert data.created_at == "2020-06-05T18:08:00Z"
        assert data.updated_at == "2020-06-05T18:08:04Z"
      end
    end
  end

  describe ".transfer_domain_out" do
    test "requests the transfer out and returns an empty Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/authorize_transfer_out"
      method      = "post"
      fixture     = "authorizeDomainTransferOut/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.transfer_domain_out(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response
        assert is_nil(response.data)
      end
    end
  end


  describe ".enable_domain_auto_renewal" do
    test "enables auto renewal for the domain and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/auto_renewal"
      method  = "put"
      fixture = "enableDomainAutoRenewal/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.enable_domain_auto_renewal(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response
        assert is_nil(response.data)
      end
    end
  end


  describe ".disable_domain_auto_renewal" do
    test "disables auto renewal for the domain and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/auto_renewal"
      method  = "delete"
      fixture = "disableDomainAutoRenewal/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.disable_domain_auto_renewal(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response
        assert is_nil(response.data)
      end
    end
  end


  describe ".enable_domain_transfer_lock" do
    test "enables the transfer lock for the domain and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/transfer_lock"
      method  = "post"
      fixture = "enableDomainTransferLock/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.enable_domain_transfer_lock(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.TransferLock
        assert data.enabled == true
      end
    end
  end

  describe ".disable_domain_transfer_lock" do
    test "disables the transfer lock for the domain and returns an empty Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/transfer_lock"
      method  = "delete"
      fixture = "disableDomainTransferLock/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.disable_domain_transfer_lock(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.TransferLock
        assert data.enabled == false
      end
    end
  end

  describe ".get_domain_transfer_lock" do
    test "returns the transfer lock for the domain in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/transfer_lock"
      method  = "get"
      fixture = "getDomainTransferLock/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_domain_transfer_lock(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.TransferLock
        assert data.enabled == true
      end
    end
  end


  describe ".get_whois_privacy" do
    test "returns the whois privacy in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/whois_privacy"
      method  = "get"
      fixture = "getWhoisPrivacy/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_whois_privacy(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.WhoisPrivacy
        assert data.id == 1
        assert data.domain_id == 2
        assert data.enabled == true
        assert data.expires_on == "2017-02-13"
        assert data.created_at == "2016-02-13T14:34:50Z"
        assert data.updated_at == "2016-02-13T14:34:52Z"
      end
    end
  end


  describe ".enable_whois_privacy" do
    test "enables the whois privacy and returns it in a Dnsimple.Response" do
      url         = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/whois_privacy"
      method      = "put"
      fixture     = "enableWhoisPrivacy/created.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: nil) do
        {:ok, response} = @module.enable_whois_privacy(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.WhoisPrivacy
        assert data.id == 1
        assert data.domain_id == 2
        assert data.enabled == nil
        assert data.expires_on == nil
        assert data.created_at == "2016-02-13T14:34:50Z"
        assert data.updated_at == "2016-02-13T14:34:50Z"
      end
    end
  end


  describe ".disable_whois_privacy" do
    test "disables the whois privacy and returns it in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/whois_privacy"
      method  = "delete"
      fixture = "disableWhoisPrivacy/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.disable_whois_privacy(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.WhoisPrivacy
        assert data.id == 1
        assert data.domain_id == 2
        assert data.enabled == false
        assert data.expires_on == "2017-02-13"
        assert data.created_at == "2016-02-13T14:34:50Z"
        assert data.updated_at == "2016-02-13T14:36:38Z"
      end
    end
  end


  describe ".renew_whois_privacy" do
    test "renews the whois privacy and returns it in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/example.com/whois_privacy/renewals"
      method  = "post"
      fixture = "renewWhoisPrivacy/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.renew_whois_privacy(@client, @account_id, "example.com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.WhoisPrivacyRenewal
        assert data.id == 1
        assert data.domain_id == 100
        assert data.whois_privacy_id == 999
        assert data.state == "new"
        assert data.enabled == true
        assert data.expires_on == "2020-01-10"
        assert data.created_at == "2019-01-10T12:12:48Z"
        assert data.updated_at == "2019-01-10T12:12:48Z"
      end
    end
  end


  describe ".get_domain_delegation" do
    test "returns the name servers in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/#{@domain_id}/delegation"
      method  = "get"
      fixture = "getDomainDelegation/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.get_domain_delegation(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert data == ~w(ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com)
      end
    end
  end


  describe ".change_domain_delegation" do
    test "changes the name servers and returns them Dnsimple.Response" do
      url          = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/#{@domain_id}/delegation"
      method       = "put"
      fixture      = "changeDomainDelegation/success.http"
      name_servers = ["ns1.dnsimple.com", "ns2.dnsimple.com", "ns3.dnsimple.com", "ns4.dnsimple.com"]
      body         = Poison.encode!(name_servers)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = @module.change_domain_delegation(@client, @account_id, @domain_id, name_servers)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert data == ~w(ns1.dnsimple.com ns2.dnsimple.com ns3.dnsimple.com ns4.dnsimple.com)
      end
    end
  end


  describe ".change_domain_delegation_to_vanity" do
    test "changes the delegation to vanity name servers and returns them Dnsimple.Response" do
      url          = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/#{@domain_id}/delegation/vanity"
      method       = "put"
      fixture      = "changeDomainDelegationToVanity/success.http"
      name_servers = ["ns1.example.com", "ns2.example.com", "ns3.example.com", "ns4.example.com"]
      body         = Poison.encode!(name_servers)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body)  do
        {:ok, response} = @module.change_domain_delegation_to_vanity(@client, @account_id, @domain_id, name_servers)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.VanityNameServer end)

        [first | _] = data
        assert first.id == 1
        assert first.name == "ns1.example.com"
        assert first.ipv4 == "127.0.0.1"
        assert first.ipv6 == "::1"
        assert first.created_at == "2016-07-11T09:40:19Z"
        assert first.updated_at == "2016-07-11T09:40:19Z"
      end
    end
  end


  describe ".change_domain_delegation_from_vanity" do
    test "changes the delegation from vanity name servers and returns an empty Dnsimple.Response" do
      url          = "#{@client.base_url}/v2/#{@account_id}/registrar/domains/#{@domain_id}/delegation/vanity"
      method       = "delete"
      fixture      = "changeDomainDelegationFromVanity/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.change_domain_delegation_from_vanity(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response
        assert response.data == nil
      end
    end
  end

  describe ".check_registrant_change" do
    test "returns the registrant change check in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/registrant_changes/check"
      method  = "post"
      fixture = "checkRegistrantChange/success.http"
      attributes  = %{domain_id: @domain_id, contact_id: 101}
      {:ok, _body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.check_registrant_change(@client, @account_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.RegistrantChangeCheck
        assert data.contact_id == 101
        assert data.domain_id == 101
        assert data.extended_attributes == []
        assert data.registry_owner_change == true
      end
    end
  end

  describe ".get_registrant_change" do
    test "returns the registrant change in a Dnsimple.Response" do
      registrant_change_id = 1
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/registrant_changes/#{registrant_change_id}"
      method  = "get"
      fixture = "getRegistrantChange/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.get_registrant_change(@client, @account_id, registrant_change_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.RegistrantChange
        assert data.id == 101
        assert data.account_id == 101
        assert data.domain_id == 101
        assert data.contact_id == 101
        assert data.state == "new"
        assert data.extended_attributes == %{}
        assert data.registry_owner_change == true
        assert data.irt_lock_lifted_by == nil
        assert data.created_at == "2017-02-03T17:43:22Z"
        assert data.updated_at == "2017-02-03T17:43:22Z"
      end
    end
  end

  describe ".create_registrant_change" do
    test "returns the registrant change in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/registrant_changes"
      method  = "post"
      fixture = "createRegistrantChange/success.http"
      attributes  = %{domain_id: @domain_id, contact_id: 101}
      {:ok, _body} = Poison.encode(attributes)

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.create_registrant_change(@client, @account_id, attributes)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.RegistrantChange
        assert data.id == 101
        assert data.account_id == 101
        assert data.domain_id == 101
        assert data.contact_id == 101
        assert data.state == "new"
        assert data.extended_attributes == %{}
        assert data.registry_owner_change == true
        assert data.irt_lock_lifted_by == nil
        assert data.created_at == "2017-02-03T17:43:22Z"
        assert data.updated_at == "2017-02-03T17:43:22Z"
      end
    end
  end

  describe ".list_registrant_changes" do
    test "returns the registrant changes in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/registrant_changes"
      method  = "get"
      fixture = "listRegistrantChanges/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.list_registrant_changes(@client, @account_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 1

        [first | _] = data
        assert first.__struct__ == Dnsimple.RegistrantChange
        assert first.id == 101
        assert first.account_id == 101
        assert first.domain_id == 101
        assert first.contact_id == 101
        assert first.state == "new"
        assert first.extended_attributes == %{}
        assert first.registry_owner_change == true
        assert first.irt_lock_lifted_by == nil
        assert first.created_at == "2017-02-03T17:43:22Z"
        assert first.updated_at == "2017-02-03T17:43:22Z"
      end
    end
  end

  describe ".delete_registrant_change" do
    test "returns nil for successful sync cancallation response wrapped in a Dnsimple.Response" do
      registrant_change_id = 1
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/registrant_changes/#{registrant_change_id}"
      method  = "delete"
      fixture = "deleteRegistrantChange/success.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.delete_registrant_change(@client, @account_id, registrant_change_id)
        assert response.__struct__ == Dnsimple.Response

        assert is_nil(response.data)
      end
    end

    test "returns registrant change object for async cancellation in a Dnsimple.Response" do
      registrant_change_id = 1
      url     = "#{@client.base_url}/v2/#{@account_id}/registrar/registrant_changes/#{registrant_change_id}"
      method  = "delete"
      fixture = "deleteRegistrantChange/success_async.http"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.delete_registrant_change(@client, @account_id, registrant_change_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.RegistrantChange
        assert data.id == 101
        assert data.account_id == 101
        assert data.domain_id == 101
        assert data.contact_id == 101
        assert data.state == "cancelling"
        assert data.extended_attributes == %{}
        assert data.registry_owner_change == true
        assert data.irt_lock_lifted_by == nil
        assert data.created_at == "2017-02-03T17:43:22Z"
        assert data.updated_at == "2017-02-03T17:43:22Z"
      end
    end
  end
end
