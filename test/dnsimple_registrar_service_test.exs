defmodule DnsimpleRegistrarServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.RegistrarService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test ".check_domain" do
    fixture = "checkDomain/success.http"
    method  = "get"
    url     = "#{@client.base_url}/v2/a/1010/registrar/domains/example.com/check"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.check_domain(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.DomainCheck
      assert response.data == %Dnsimple.DomainCheck{domain: "example.com", available: true, premium: false}
    end
  end

  test ".register_domain" do
    fixture     = "registerDomain/success.http"
    method      = "post"
    url         = "#{@client.base_url}/v2/a/1010/registrar/domains/example.com/registration"
    attributes  = %{registrant_id: 2, auto_renew: false, privacy: false}
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.register_domain(@client, "1010", "example.com", attributes)

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.Domain
      assert response.data == %Dnsimple.Domain{
        id: 1,
        name: "example.com",
        account_id: 1010,
        registrant_id: 2,
        auto_renew: false,
        private_whois: false,
        state: "registered",
        token: "cc8h1jP8bDLw5rXycL16k8BivcGiT6K9",
        created_at: "2016-01-16T16:08:50.649Z",
        updated_at: "2016-01-16T16:09:01.161Z",
        expired_on: nil,
      }
    end
  end

end
