defmodule Dnsimple.TldsTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Tlds
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}

  test "poison test" do
    body = """
{"data":[{"name":"uk_legal_type","description":"Legal type of registrant contact","required":false,"options":[{"title":"UK Individual","value":"IND","description":"UK Individual (our default value)"},{"title":"Non-UK Individual (representing self)","value":"FIND","description":"Non-UK Individual (representing self)"},{"title":"UK Limited Company","value":"LTD","description":"UK Limited Company"},{"title":"UK Public Limited Company","value":"PLC","description":"UK Public Limited Company"},{"title":"UK Partnership","value":"PTNR","description":"UK Partnership"},{"title":"UK LLP","value":"LLP","description":"UK Limited Liability Partnership"},{"title":"UK Sole Trader","value":"STRA","description":"UK Sole Trader"},{"title":"UK Registered Charity","value":"RCHAR","description":"UK Registered Charity"},{"title":"UK Industrial/Provident Registered Company","value":"IP","description":"UK Industrial/Provident Registered Company"},{"title":"UK School","value":"SCH","description":"UK School"},{"title":"Other Foreign","value":"FOTHER","description":"Other foreign organizations"},{"title":"UK Government Body","value":"GOV","description":"UK Government Body"},{"title":"UK Corporation by Royal Charter","value":"CRC","description":"UK Corporation by Royal Charter"},{"title":"UK Statutory Body","value":"STAT","description":"UK Statutory Body"},{"title":"UK Entity (other)","value":"OTHER","description":"UK Entity (other)"},{"title":"Non-UK Corporation","value":"FCORP","description":"Non-UK Corporation"},{"title":"Non-UK Organization (other)","value":"FOTHER","description":"Non-UK Organization"}]},{"name":"uk_reg_co_no","description":"Company identification number","required":false,"options":[]},{"name":"registered_for","description":"Company or person domain is registered for (this must be accurate and CANNOT BE CHANGED)","required":true,"options":[]},{"name":"uk_reg_opt_out","description":"Hide registrant data in Nominet WHOIS","required":false,"options":[{"title":"No","value":"n","description":"Do not hide the registrant contact information in Nominet's WHOIS."},{"title":"Yes","value":"y","description":"Hide the registrant contact information in Nominet's WHOIS (only available to individuals)."}]}]}
    """
    {:ok, result} = Poison.decode(body, as: %{"data" => [%Dnsimple.TldExtendedAttribute{options: [%Dnsimple.TldExtendedAttribute.Option{}]}]})

    data = Map.get(result, "data")

    [first_attribute | _] = data
    assert first_attribute.__struct__ == Dnsimple.TldExtendedAttribute
    assert first_attribute.name == "uk_legal_type"
    assert first_attribute.description == "Legal type of registrant contact"
    assert first_attribute.required == false
    assert is_list(first_attribute.options)

    [first_option | _] = first_attribute.options
    assert first_option.__struct__ == Dnsimple.TldExtendedAttribute.Option
    assert first_option.title == "UK Individual"
    assert first_option.value == "IND"
    assert first_option.description == "UK Individual (our default value)"
  end

  describe ".list_tlds" do
    setup do
      url = "#{@client.base_url}/v2/tlds"
      {:ok, fixture: "listTlds/success.http", method: "get", url: url}
    end

    test "returns the TLDs in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.list_tlds(@client)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Tld end)
      end
    end

    test "supports custom headers", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_tlds(@client, headers: %{"X-Header" => "X-Value"})
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "supports sorting", %{fixture: fixture_file, method: method} do
      url = "#{@client.base_url}/v2/tlds?sort=tld%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.list_tlds(@client, sort: "tld:desc")
        assert response.__struct__ == Dnsimple.Response
      end
    end

    test "can be called using the alias .tlds", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.tlds(@client)
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_tld" do
    setup do
      url = "#{@client.base_url}/v2/tlds/com"
      {:ok, fixture: "getTld/success.http", method: "get", url: url}
    end

    test "returns the TLD in a Dnsimple.Response", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.get_tld(@client, "com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Tld
        assert data.tld == "com"
        assert data.tld_type == 1
        assert data.idn == true
        assert data.whois_privacy == true
        assert data.auto_renew_only == false
        assert data.minimum_registration == 1
      end
    end

    test "can be called using the alias .tld", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.tld(@client, "com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end


  describe ".get_tld_extended_attributes" do
    setup do
      url = "#{@client.base_url}/v2/tlds/com/extended_attributes"
      {:ok, fixture: "getTldExtendedAttributes/success.http", method: "get", url: url}
    end

    test "returns the extended attributes in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url)  do
        {:ok, response} = @module.get_tld_extended_attributes(@client, "com")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 4
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.TldExtendedAttribute end)

        [attribute | _] = data
        assert attribute.name == "uk_legal_type"
        assert attribute.description == "Legal type of registrant contact"
        assert attribute.required == false
        assert Enum.all?(attribute.options, fn(single) -> single.__struct__ == Dnsimple.TldExtendedAttribute.Option end)

        [option | _] = attribute.options
        assert option.title == "UK Individual"
        assert option.value == "IND"
        assert option.description == "UK Individual (our default value)"
      end
    end

    test "can be called using the alias .tld_extended_attributes", %{fixture: fixture_file, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture_file, method: method, url: url) do
        {:ok, response} = @module.tld_extended_attributes(@client, "com")
        assert response.__struct__ == Dnsimple.Response
      end
    end
  end

end
