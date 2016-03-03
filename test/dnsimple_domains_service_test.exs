defmodule DnsimpleDomainsServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.DomainsService

  @service Dnsimple.DomainsService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".domains builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listDomains/success.http", [url: @client.base_url <> "/v2/1010/domains"])
    use_cassette :stub, fixture do
      @service.domains(@client, "1010")
    end
  end

  test ".domains returns a list of Dnsimple.Domain" do
    use_cassette :stub, ExvcrUtils.response_fixture("listDomains/success.http", [url: "~r/\/domains$/"]) do
      response = @service.domains(@client, "1010")
      assert is_list(response)
      assert length(response) == 2
      assert Enum.all?(response, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      assert Enum.all?(response, fn(single) -> is_integer(single.id) end)
    end
  end


  test ".domain builds the correct request" do
    fixture = ExvcrUtils.response_fixture("getDomain/success.http", [url: @client.base_url <> "/v2/1010/domains/example.weppos"])
    use_cassette :stub, fixture do
      @service.domain(@client, "1010", "example.weppos")
    end
  end

  test ".domain returns a Dnsimple.Domain" do
    use_cassette :stub, ExvcrUtils.response_fixture("getDomain/success.http", [url: "~r/\/domains/.+$/"]) do
      response = @service.domain(@client, "_", "example.weppos")
      assert is_map(response)
      assert response.__struct__ == Dnsimple.Domain
      assert response.id == 1
      assert response.name == "example-alpha.com"
    end
  end

end

