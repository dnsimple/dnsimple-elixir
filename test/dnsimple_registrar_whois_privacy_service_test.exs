defmodule DnsimpleRegistrarWhoisPrivacyServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.RegistrarWhoisPrivacyService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test ".whois_privacy" do
    fixture = "getWhoisPrivacy/success.http"
    method  = "get"
    url     = "#{@client.base_url}/v2/1010/registrar/domains/example.com/whois_privacy"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.whois_privacy(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.WhoisPrivacy
      assert response.data == %Dnsimple.WhoisPrivacy{
        id: 1,
        domain_id: 2,
        enabled: true,
        expires_on: "2017-02-13",
        created_at: "2016-02-13T14:34:50.135Z",
        updated_at: "2016-02-13T14:34:52.571Z",
      }
    end
  end

  test ".enable_whois_privacy" do
    fixture     = "enableWhoisPrivacy/created.http"
    method      = "put"
    url         = "#{@client.base_url}/v2/1010/registrar/domains/example.com/whois_privacy"
    attributes  = []
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.enable_whois_privacy(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.WhoisPrivacy
      assert response.data == %Dnsimple.WhoisPrivacy{
        id: 1,
        domain_id: 2,
        enabled: nil,
        expires_on: nil,
        created_at: "2016-02-13T14:34:50.135Z",
        updated_at: "2016-02-13T14:34:50.135Z",
      }
    end
  end

  test ".disable_whois_privacy" do
    fixture = "disableWhoisPrivacy/success.http"
    method  = "delete"
    url     = "#{@client.base_url}/v2/1010/registrar/domains/example.com/whois_privacy"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.disable_whois_privacy(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.WhoisPrivacy
      assert response.data == %Dnsimple.WhoisPrivacy{
        id: 1,
        domain_id: 2,
        enabled: false,
        expires_on: "2017-02-13",
        created_at: "2016-02-13T14:34:50.135Z",
        updated_at: "2016-02-13T14:36:38.964Z",
      }
    end
  end

end
