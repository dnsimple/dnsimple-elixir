defmodule Dnsimple.CertificatesTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @module Dnsimple.Certificates
  @client %Dnsimple.Client{access_token: "i-am-a-token", base_url: "https://api.dnsimple.test"}
  @account_id 1010
  @domain_id "example.com"

  describe ".list_certificates" do
    setup do
      url = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/certificates"
      {:ok, fixture: "listCertificates/success.http", method: "get", url: url}
    end

    test "returns the certificates in a Dnsimple.Response", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.list_certificates(@client, @account_id, @domain_id)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert is_list(data)
        assert length(data) == 2
        assert Enum.all?(data, fn(single) -> single.__struct__ == Dnsimple.Certificate end)
      end
    end

    test "sends custom headers", %{fixture: fixture, method: method, url: url} do
      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        @module.list_certificates(@client, "1010", "example.com", headers: %{"X-Header" => "X-Value"})
      end
    end

    test "supports sorting", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/1010/domains/example.com/certificates?sort=id%3Adesc"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        @module.list_certificates(@client, "1010", "example.com", sort: "id:desc")
      end
    end

    test "supports filtering", %{fixture: fixture, method: method} do
      url = "#{@client.base_url}/v2/1010/domains/example.com/certificates?common_name_like=www"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        @module.list_certificates(@client, "1010", "example.com", filter: [common_name_like: "www"])
      end
    end
  end


  describe ".get_certificate" do
    test "returns the certificate in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/certificates/1"
      fixture = "getCertificate/success.http"
      method  = "get"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_certificate(@client, @account_id, @domain_id, _certificate_id = 1)
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Certificate
        assert data.id == 1
        assert data.name == "www"
      end
    end
  end


  describe ".download_certificate" do
    test "returns the certificate in a Dnsimple.Response" do
      url = "#{@client.base_url}/v2/1010/domains/example.com/certificates/22289/download"
      use_cassette :stub, ExvcrUtils.response_fixture("downloadCertificate/success.http", method: "get", url: url) do
        {:ok, response} = @module.download_certificate(@client, "1010", "example.com", _certificate_id = "22289")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Certificate
        assert data.server == "-----BEGIN CERTIFICATE-----\nMIIE7TCCA9WgAwIBAgITAPpTe4O3vjuQ9L4gLsogi/ukujANBgkqhkiG9w0BAQsF\nADAiMSAwHgYDVQQDDBdGYWtlIExFIEludGVybWVkaWF0ZSBYMTAeFw0xNjA2MTEx\nNzQ4MDBaFw0xNjA5MDkxNzQ4MDBaMBkxFzAVBgNVBAMTDnd3dy53ZXBwb3MubmV0\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtzCcMfWoQRt5AMEY0HUb\n2GaraL1GsWOo6YXdPfe+YDvtnmDw23NcoTX7VSeCgU9M3RKs19AsCJcRNTLJ2dmD\nrAuyCTud9YTAaXQcTOLUhtO8T8+9AFVIva2OmAlKCR5saBW3JaRxW7V2aHEd/d1s\ns1CvNOO7jNppc9NwGSnDHcn3rqNv/U3MaU0gpJJRqsKkvcLU6IHJGgxyQ6AbpwJD\nIqBnzkjHu2IuhGEbRuMjyWLA2qtsjyVlfPotDxUdVouUQpz7dGHUFrLR7ma8QAYu\nOfl1ZMyrc901HGMa7zwbnFWurs3fed7vAosTRZIjnn72/3Wo7L9RiMB+vwr3NX7c\n9QIDAQABo4ICIzCCAh8wDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUF\nBwMBBggrBgEFBQcDAjAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBRh9q/3Zxbk4yA/\nt7j+8xA+rkiZBTAfBgNVHSMEGDAWgBTAzANGuVggzFxycPPhLssgpvVoOjB4Bggr\nBgEFBQcBAQRsMGowMwYIKwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnN0Zy1pbnQteDEu\nbGV0c2VuY3J5cHQub3JnLzAzBggrBgEFBQcwAoYnaHR0cDovL2NlcnQuc3RnLWlu\ndC14MS5sZXRzZW5jcnlwdC5vcmcvMCUGA1UdEQQeMByCCndlcHBvcy5uZXSCDnd3\ndy53ZXBwb3MubmV0MIH+BgNVHSAEgfYwgfMwCAYGZ4EMAQIBMIHmBgsrBgEEAYLf\nEwEBATCB1jAmBggrBgEFBQcCARYaaHR0cDovL2Nwcy5sZXRzZW5jcnlwdC5vcmcw\ngasGCCsGAQUFBwICMIGeDIGbVGhpcyBDZXJ0aWZpY2F0ZSBtYXkgb25seSBiZSBy\nZWxpZWQgdXBvbiBieSBSZWx5aW5nIFBhcnRpZXMgYW5kIG9ubHkgaW4gYWNjb3Jk\nYW5jZSB3aXRoIHRoZSBDZXJ0aWZpY2F0ZSBQb2xpY3kgZm91bmQgYXQgaHR0cHM6\nLy9sZXRzZW5jcnlwdC5vcmcvcmVwb3NpdG9yeS8wDQYJKoZIhvcNAQELBQADggEB\nAEqMdWrmdIyQxthWsX3iHmM2h/wXwEesD0VIaA+Pq4mjwmKBkoPSmHGQ/O4v8RaK\nB6gl8v+qmvCwwqC1SkBmm+9C2yt/P6WhAiA/DD+WppYgJWfcz2lEKrgufFlHPukB\nDzE0mJDuXm09QTApWlaTZWYfWKY50T5uOT/rs+OwGFFCO/8o7v5AZRAHos6uzjvq\nAtFZj/FEnXXMjSSlQ7YKTXToVpnAYH4e3/UMsi6/O4orkVz82ZfhKwMWHV8dXlRw\ntQaemFWTjGPgSLXJAtQO30DgNJBHX/fJEaHv6Wy8TF3J0wOGpzGbOwaTX8YAmEzC\nlzzjs+clg5MN5rd1g4POJtU=\n-----END CERTIFICATE-----\n"
        assert data.chain == ["-----BEGIN CERTIFICATE-----\nMIIEqzCCApOgAwIBAgIRAIvhKg5ZRO08VGQx8JdhT+UwDQYJKoZIhvcNAQELBQAw\nGjEYMBYGA1UEAwwPRmFrZSBMRSBSb290IFgxMB4XDTE2MDUyMzIyMDc1OVoXDTM2\nMDUyMzIyMDc1OVowIjEgMB4GA1UEAwwXRmFrZSBMRSBJbnRlcm1lZGlhdGUgWDEw\nggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDtWKySDn7rWZc5ggjz3ZB0\n8jO4xti3uzINfD5sQ7Lj7hzetUT+wQob+iXSZkhnvx+IvdbXF5/yt8aWPpUKnPym\noLxsYiI5gQBLxNDzIec0OIaflWqAr29m7J8+NNtApEN8nZFnf3bhehZW7AxmS1m0\nZnSsdHw0Fw+bgixPg2MQ9k9oefFeqa+7Kqdlz5bbrUYV2volxhDFtnI4Mh8BiWCN\nxDH1Hizq+GKCcHsinDZWurCqder/afJBnQs+SBSL6MVApHt+d35zjBD92fO2Je56\ndhMfzCgOKXeJ340WhW3TjD1zqLZXeaCyUNRnfOmWZV8nEhtHOFbUCU7r/KkjMZO9\nAgMBAAGjgeMwgeAwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw\nHQYDVR0OBBYEFMDMA0a5WCDMXHJw8+EuyyCm9Wg6MHoGCCsGAQUFBwEBBG4wbDA0\nBggrBgEFBQcwAYYoaHR0cDovL29jc3Auc3RnLXJvb3QteDEubGV0c2VuY3J5cHQu\nb3JnLzA0BggrBgEFBQcwAoYoaHR0cDovL2NlcnQuc3RnLXJvb3QteDEubGV0c2Vu\nY3J5cHQub3JnLzAfBgNVHSMEGDAWgBTBJnSkikSg5vogKNhcI5pFiBh54DANBgkq\nhkiG9w0BAQsFAAOCAgEABYSu4Il+fI0MYU42OTmEj+1HqQ5DvyAeyCA6sGuZdwjF\nUGeVOv3NnLyfofuUOjEbY5irFCDtnv+0ckukUZN9lz4Q2YjWGUpW4TTu3ieTsaC9\nAFvCSgNHJyWSVtWvB5XDxsqawl1KzHzzwr132bF2rtGtazSqVqK9E07sGHMCf+zp\nDQVDVVGtqZPHwX3KqUtefE621b8RI6VCl4oD30Olf8pjuzG4JKBFRFclzLRjo/h7\nIkkfjZ8wDa7faOjVXx6n+eUQ29cIMCzr8/rNWHS9pYGGQKJiY2xmVC9h12H99Xyf\nzWE9vb5zKP3MVG6neX1hSdo7PEAb9fqRhHkqVsqUvJlIRmvXvVKTwNCP3eCjRCCI\nPTAvjV+4ni786iXwwFYNz8l3PmPLCyQXWGohnJ8iBm+5nk7O2ynaPVW0U2W+pt2w\nSVuvdDM5zGv2f9ltNWUiYZHJ1mmO97jSY/6YfdOUH66iRtQtDkHBRdkNBsMbD+Em\n2TgBldtHNSJBfB3pm9FblgOcJ0FSWcUDWJ7vO0+NTXlgrRofRT6pVywzxVo6dND0\nWzYlTWeUVsO40xJqhgUQRER9YLOLxJ0O6C8i0xFxAMKOtSdodMB3RIwt7RFQ0uyt\nn5Z5MqkYhlMI3J1tPRTp1nEt9fyGspBOO05gi148Qasp+3N+svqKomoQglNoAxU=\n-----END CERTIFICATE-----"]
      end
    end
  end


  describe ".get_certificate_private_key" do
    test "returns the private key in a Dnsimple.Response" do
      url     = "#{@client.base_url}/v2/#{@account_id}/domains/#{@domain_id}/certificates/22289/private_key"
      fixture = "getCertificatePrivateKey/success.http"
      method  = "get"

      use_cassette :stub, ExvcrUtils.response_fixture(fixture, method: method, url: url) do
        {:ok, response} = @module.get_certificate_private_key(@client, @account_id, @domain_id, _certificate_id = "22289")
        assert response.__struct__ == Dnsimple.Response

        data = response.data
        assert data.__struct__ == Dnsimple.Certificate
        assert data.private_key == "-----BEGIN RSA PRIVATE KEY-----\nMIIEowIBAAKCAQEAtzCcMfWoQRt5AMEY0HUb2GaraL1GsWOo6YXdPfe+YDvtnmDw\n23NcoTX7VSeCgU9M3RKs19AsCJcRNTLJ2dmDrAuyCTud9YTAaXQcTOLUhtO8T8+9\nAFVIva2OmAlKCR5saBW3JaRxW7V2aHEd/d1ss1CvNOO7jNppc9NwGSnDHcn3rqNv\n/U3MaU0gpJJRqsKkvcLU6IHJGgxyQ6AbpwJDIqBnzkjHu2IuhGEbRuMjyWLA2qts\njyVlfPotDxUdVouUQpz7dGHUFrLR7ma8QAYuOfl1ZMyrc901HGMa7zwbnFWurs3f\ned7vAosTRZIjnn72/3Wo7L9RiMB+vwr3NX7c9QIDAQABAoIBAEQx32OlzK34GTKT\nr7Yicmw7xEGofIGa1Q2h3Lut13whsxKLif5X0rrcyqRnoeibacS+qXXrJolIG4rP\nTl8/3wmUDQHs5J+6fJqFM+fXZUCP4AFiFzzhgsPBsVyd0KbWYYrZ0qU7s0ttoRe+\nTGjuHgIe3ip1QKNtx2Xr50YmytDydknmro79J5Gfrub1l2iA8SDm1eBrQ4SFaNQ2\nU709pHeSwX8pTihUX2Zy0ifpr0O1wYQjGLneMoG4rrNQJG/z6iUdhYczwwt1kDRQ\n4WkM2sovFOyxbBfoCQ3Gy/eem7OXfjNKUe47DAVLnPkKbqL/3Lo9FD7kcB8K87Ap\nr/vYrl0CgYEA413RAk7571w5dM+VftrdbFZ+Yi1OPhUshlPSehavro8kMGDEG5Ts\n74wEz2X3cfMxauMpMrBk/XnUCZ20AnWQClK73RB5fzPw5XNv473Tt/AFmt7eLOzl\nOcYrhpEHegtsD/ZaljlGtPqsjQAL9Ijhao03m1cGB1+uxI7FgacdckcCgYEAzkKP\n6xu9+WqOol73cnlYPS3sSZssyUF+eqWSzq2YJGRmfr1fbdtHqAS1ZbyC5fZVNZYV\nml1vfXi2LDcU0qS04JazurVyQr2rJZMTlCWVET1vhik7Y87wgCkLwKpbwamPDmlI\n9GY+fLNEa4yfAOOpvpTJpenUScxyKWH2cdYFOOMCgYBhrJnvffINC/d64Pp+BpP8\nyKN+lav5K6t3AWd4H2rVeJS5W7ijiLTIq8QdPNayUyE1o+S8695WrhGTF/aO3+ZD\nKQufikZHiQ7B43d7xL7BVBF0WK3lateGnEVyh7dIjMOdj92Wj4B6mv2pjQ2VvX/p\nAEWVLCtg24/+zL64VgxmXQKBgGosyXj1Zu2ldJcQ28AJxup3YVLilkNje4AXC2No\n6RCSvlAvm5gpcNGE2vvr9lX6YBKdl7FGt8WXBe/sysNEFfgmm45ZKOBCUn+dHk78\nqaeeQHKHdxMBy7utZWdgSqt+ZS299NgaacA3Z9kVIiSLDS4V2VeW7riujXXP/9TJ\nnxaRAoGBAMWXOfNVzfTyrKff6gvDWH+hqNICLyzvkEn2utNY9Q6WwqGuY9fvP/4Z\nXzc48AOBzUr8OeA4sHKJ79sJirOiWHNfD1swtvyVzsFZb6moiNwD3Ce/FzYCa3lQ\nU8blTH/uqpR2pSC6whzJ/lnSdqHUqhyp00000000000000000000\n-----END RSA PRIVATE KEY-----\n"
      end
    end
  end

end
