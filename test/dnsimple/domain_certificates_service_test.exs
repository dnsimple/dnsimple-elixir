defmodule Dnsimple.DomainCertificatesServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.DomainCertificatesService

  @service Dnsimple.DomainCertificatesService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".certificates builds the correct request" do
    fixture = ExvcrUtils.response_fixture("listCertificates/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/certificates"])
    use_cassette :stub, fixture do
      @service.certificates(@client, "1010", "example.com")
    end
  end

  test ".applied_services builds sends custom headers" do
    fixture = ExvcrUtils.response_fixture("listCertificates/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/certificates"])
    use_cassette :stub, fixture do
      @service.certificates(@client, "1010", "example.com", [headers: %{"X-Header" => "X-Value"}])
    end
  end

  test ".certificates supports sorting" do
    fixture = ExvcrUtils.response_fixture("listCertificates/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/certificates?sort=id%3Adesc"])
    use_cassette :stub, fixture do
      @service.certificates(@client, "1010", "example.com", [sort: "id:desc"])
    end
  end

  test ".certificates supports filtering" do
    fixture = ExvcrUtils.response_fixture("listCertificates/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/certificates?common_name_like=www"])
    use_cassette :stub, fixture do
      @service.certificates(@client, "1010", "example.com", [filter: [common_name_like: "www"]])
    end
  end

  test ".certificates returns a list of Dnsimple.Response" do
     fixture = ExvcrUtils.response_fixture("listCertificates/success.http", [method: "get"])
    use_cassette :stub, fixture do
      { :ok, response } = @service.certificates(@client, "1010", "example.com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 2
      assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Certificate end)
      assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
    end
  end
end
