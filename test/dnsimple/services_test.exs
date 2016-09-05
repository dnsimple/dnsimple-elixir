defmodule Dnsimple.ServicesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Services
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}


  test ".applied_services builds the correct request" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services"])
    use_cassette :stub, fixture do
      @module.applied_services(@client, "1010", "example.com")
    end
  end

  test ".applied_services builds sends custom headers" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services"])
    use_cassette :stub, fixture do
      @module.applied_services(@client, "1010", "example.com", [headers: %{"X-Header" => "X-Value"}])
    end
  end

  test ".applied_services supports sorting" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services?sort=id%3Adesc"])
    use_cassette :stub, fixture do
      @module.applied_services(@client, "1010", "example.com", [sort: "id:desc"])
    end
  end

  test ".applied_services supports filtering" do
    fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get", url: @client.base_url <> "/v2/1010/domains/example.com/services?name_like=example"])
    use_cassette :stub, fixture do
      @module.applied_services(@client, "1010", "example.com", [filter: [name_like: "example"]])
    end
  end

  test ".applied_services returns a list of Dnsimple.Response" do
     fixture = ExvcrUtils.response_fixture("appliedServices/success.http", [method: "get"])
    use_cassette :stub, fixture do
      {:ok, response} = @module.applied_services(@client, "1010", "example.com")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_list(data)
      assert length(data) == 1
      assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Service end)
      assert Enum.all?(data, fn(single) -> is_integer(single.id) end)
    end
  end

  test ".apply_service builds the correct request" do
    fixture = ExvcrUtils.response_fixture("applyService/success.http",  [method: "post", url: @client.base_url <> "/v2/1010/domains/example.com/services/1", request_body: ""])
    use_cassette :stub, fixture do
      @module.apply_service(@client, "1010", "example.com", _service_id = "1")
    end
  end

  test ".apply_service returns a Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("applyService/success.http", [method: "post"])
    use_cassette :stub, fixture do
      {:ok, response} = @module.apply_service(@client, "1010", "example.com", _service_id = "1")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_nil(data)
    end
  end

  test ".unapply_service builds the correct request" do
    fixture = ExvcrUtils.response_fixture("unapplyService/success.http",  [method: "delete", url: @client.base_url <> "/v2/1010/domains/example.com/services/1"])
    use_cassette :stub, fixture do
      @module.unapply_service(@client, "1010", "example.com", _service_id = "1")
    end
  end

  test ".unapply_service returns a Dnsimple.Response" do
    fixture = ExvcrUtils.response_fixture("unapplyService/success.http", [method: "delete"])
    use_cassette :stub, fixture do
      {:ok, response} = @module.unapply_service(@client, "1010", "example.com", _service_id = "1")
      assert response.__struct__ == Dnsimple.Response

      data = response.data
      assert is_nil(data)
    end
  end

end
