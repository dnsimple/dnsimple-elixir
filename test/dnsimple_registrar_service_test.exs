defmodule DnsimpleRegistrarServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @service Dnsimple.RegistrarService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test ".check_domain" do
    use_cassette :stub, ExvcrUtils.response_fixture("checkDomain/success.http", method: "get", url: "#{@client.base_url}/v2/registrar/domains/example.com/check") do
      { :ok, response } = @service.check_domain(@client, "example.com")

      assert response.__struct__ == Dnsimple.Response
      assert response.data.__struct__ == Dnsimple.DomainCheck
      assert response.data == %Dnsimple.DomainCheck{domain: "example.com", available: true, premium: false}
    end
  end

end
