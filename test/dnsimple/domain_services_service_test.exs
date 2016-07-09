defmodule Dnsimple.DomainServicesServiceTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.DomainServicesService

  @service Dnsimple.DomainServicesService
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".applied_services builds the correct request" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services"])
    use_cassette :stub, fixture do
      @service.applied_services(@client, "1010", "example.com")
    end
  end

  test ".applied_services builds sends custom headers" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services"])
    use_cassette :stub, fixture do
      @service.applied_services(@client, "1010", "example.com", [headers: %{"X-Header" => "X-Value"}])
    end
  end

  test ".applied_services supports sorting" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services?sort=id%3Adesc"])
    use_cassette :stub, fixture do
      @service.applied_services(@client, "1010", "example.com", [sort: "id:desc"])
    end
  end

  test ".applied_services supports filtering" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services?name_like=example"])
    use_cassette :stub, fixture do
      @service.applied_services(@client, "1010", "example.com", [filter: [name_like: "example"]])
    end
  end

  test ".applied_services returns a list of Dnsimple.Response" do
     fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get"])
    use_cassette :stub, fixture do
      { :ok, response } = @service.applied_services(@client, "1010", "example.com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 1
      assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Service end)
      assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
    end
  end
end
