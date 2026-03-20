defmodule ExvcrUtilsTest do
  use TestCase, async: false

  test ".read_fixture reads the fixture from file" do
    fixture = ExvcrUtils.read_fixture("checkDomain/success.http")

    assert fixture == """
    HTTP/1.1 200 OK
    server: nginx
    date: Fri, 26 Feb 2016 16:04:05 GMT
    content-type: application/json; charset=utf-8
    connection: keep-alive
    status: 200 OK
    x-ratelimit-limit: 4000
    x-ratelimit-remaining: 3999
    x-ratelimit-reset: 1456506245
    etag: W/"f3cf8499e935e48401aae26842f712c4"
    cache-control: max-age=0, private, must-revalidate
    x-request-id: e3c6fac1-a36d-42c3-8a04-d68f127add18
    x-runtime: 0.605907
    strict-transport-security: max-age=31536000

    {"data":{"domain":"ruby.codes","available":true,"premium":true}}
    """
  end

  test "break_into_parts splits the fixture into status, headers and body" do
    fixture = """
    HTTP/1.1 200 OK
    Server: nginx
    Content-Type: application/json; charset=utf-8

    {"data":{"domain":"example.com","available":true,"premium":false}}
    """

    [status, headers, body] = ExvcrUtils.break_into_parts(fixture)

    assert body == "{\"data\":{\"domain\":\"example.com\",\"available\":true,\"premium\":false}}\n"
    assert status == "HTTP/1.1 200 OK"
    assert headers == "Server: nginx\nContent-Type: application/json; charset=utf-8"
  end

  test "extract_code extracts the code from the status" do
    status = "HTTP/1.1 200 OK"

    assert ExvcrUtils.extract_code(status) == 200
  end

  test "extract_headers extracts keys and values from headers" do
    headers    = "Server: nginx\nContent-Type: application/json; charset=utf-8\r\nStatus: 201 Created"
    key_values = %{
      "Server" => "nginx",
      "Status" => "201 Created",
      "Content-Type" => "application/json; charset=utf-8",
    }

    assert ExvcrUtils.extract_headers(headers) == key_values
  end

end
