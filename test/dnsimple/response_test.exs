defmodule Dnsimple.ResponseTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Dnsimple.Client


  test ".new" do
    client = %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}
    use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", [method: "GET"]) do
      { :ok, http } = Dnsimple.Client.execute(client, "GET", "/path")
      response = Dnsimple.Response.new(http, nil)

      assert response.http_response == http
      assert response.data == nil
    end
  end

  test ".new parses the rate-limit" do
    client = %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}
    use_cassette :stub, ExvcrUtils.response_fixture("whoami/success.http", [method: "GET"]) do
      { :ok, http } = Dnsimple.Client.execute(client, "GET", "/path")
      response = Dnsimple.Response.new(http, nil)

      assert response.rate_limit == 4000
      assert response.rate_limit_remaining == 3991
      assert response.rate_limit_reset == 1450451976
    end
  end


  test ".parse parses responses into structs without a data attribute" do
    client = %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}
    use_cassette :stub, ExvcrUtils.response_fixture("oauthAccessToken/success.http", [method: "POST"]) do
      http_response   = Dnsimple.Client.execute(client, "POST", "/oauth/access_token")
      {:ok, response} = Dnsimple.Response.parse(http_response, Dnsimple.OauthToken)

      assert response.data.__struct__ == Dnsimple.OauthToken
    end
  end

  test ".parse parses pagination" do
    client = %Dnsimple.Client{access_token: "x", base_url: "https://api.dnsimple.test"}
    use_cassette :stub, ExvcrUtils.response_fixture("pages1of3.http", [method: "GET"]) do
      http_response = Dnsimple.Client.execute(client, "GET", "/path")
      {:ok, response} = Dnsimple.Response.parse(http_response, nil)

      assert response.pagination != nil
      assert response.pagination.current_page == 1
      assert response.pagination.per_page == 2
      assert response.pagination.total_pages == 3
      assert response.pagination.total_entries == 5
    end
  end

end
