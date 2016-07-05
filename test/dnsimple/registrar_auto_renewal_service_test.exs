defmodule Dnsimple.RegistrarAutoRenewalServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.RegistrarAutoRenewalService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test ".enableDomainAutoRenewal" do
    fixture = "enableDomainAutoRenewal/success.http"
    method  = "put"
    url     = "#{@client.base_url}/v2/1010/registrar/domains/example.com/auto_renewal"
    attributes  = []
    {:ok, body} = Poison.encode(attributes)

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url, request_body: body) do
      {:ok, response} = @service.enable_auto_renewal(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert is_nil(response.data)
    end
  end

  test ".disableDomainAutoRenewal" do
    fixture = "disableDomainAutoRenewal/success.http"
    method  = "delete"
    url     = "#{@client.base_url}/v2/1010/registrar/domains/example.com/auto_renewal"

    use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
      {:ok, response} = @service.disable_auto_renewal(@client, "1010", "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert is_nil(response.data)
    end
  end

end
