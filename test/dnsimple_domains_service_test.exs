defmodule DnsimpleDomainsServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.DomainsService

  @service Dnsimple.DomainsService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".domains builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains"])
    use_cassette :stub, fixture do
      @service.domains(@client, "1010")
    end
  end

  test ".domains supports sorting" do
    fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains?sort=id%3Adesc"])
    use_cassette :stub, fixture do
      @service.domains(@client, "1010", [], [sort: "id:desc"])
    end
  end

  test ".domains supports filtering" do
    fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains?name_like=example"])
    use_cassette :stub, fixture do
      @service.domains(@client, "1010", [], [filter: [name_like: "example"]])
    end
  end

  test ".domains returns a list of Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("listDomains/success.http", [method: "get"])
    use_cassette :stub, fixture do
      { :ok, response } = @service.domains(@client, "1010")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Domain end)
      assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
    end
  end


  test ".create_domain builds the correct request" do
    fixture = ExvcrUtils.response_fixture("createDomain/created.http", [method: "post", url: @client.base_url <> "/v2/1010/domains", request_body: ~s'{"name":"example.com"}'])
    use_cassette :stub, fixture do
      @service.create_domain(@client, "1010", %{ name: "example.com" })
    end
  end

  test ".create_domains returns a Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("createDomain/created.http", [method: "post", request_body: ""])
    use_cassette :stub, fixture do
      { :ok, response } = @service.create_domain(@client, "1010", "")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_map(data)
      assert data.__struct__ == Dnsimple.Domain
      assert data.id == 1
      assert data.name == "example-alpha.com"
    end
  end


  test ".domain builds the correct request" do
    fixture = ExvcrUtils.response_fixture("getDomain/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.weppos"])
    use_cassette :stub, fixture do
      @service.domain(@client, "1010", "example.weppos")
    end
  end

  test ".domain returns a Dnsimple.Response" do
    use_cassette :stub, ExvcrUtils.response_fixture("getDomain/success.http", [method: "get"]) do
      { :ok, response } = @service.domain(@client, "_", "example.weppos")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_map(data)
      assert data.__struct__ == Dnsimple.Domain
      assert data.id == 1
      assert data.name == "example-alpha.com"
    end
  end


  test ".delete_domain builds the correct request" do
    fixture = ExvcrUtils.response_fixture("deleteDomain/success.http", [method: "delete", url: @client.base_url <> "/v2/1010/domains/example.weppos"])
    use_cassette :stub, fixture do
      @service.delete_domain(@client, "1010", "example.weppos")
    end
  end

  test ".delete_domain returns a Dnsimple.Response" do
    use_cassette :stub, ExvcrUtils.response_fixture("deleteDomain/success.http", [method: "delete"]) do
      { :ok, response } = @service.delete_domain(@client, "_", "example.weppos")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_nil(data)
    end
  end

end
