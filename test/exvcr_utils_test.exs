defmodule ExvcrUtilsTest do
  use TestCase, async: false

  test ".read_fixture reads the fixture from file" do
    fixture = ExvcrUtils.read_fixture("checkDomain/success.http")

    assert fixture == """
    HTTP/1.1 200 OK\r
    Server: nginx\r
    Date: Fri, 26 Feb 2016 16:04:05 GMT\r
    Content-Type: application/json; charset=utf-8\r
    Connection: keep-alive\r
    Status: 200 OK\r
    X-RateLimit-Limit: 4000\r
    X-RateLimit-Remaining: 3999\r
    X-RateLimit-Reset: 1456506245\r
    ETag: W/"f3cf8499e935e48401aae26842f712c4"\r
    Cache-Control: max-age=0, private, must-revalidate\r
    X-Request-Id: e3c6fac1-a36d-42c3-8a04-d68f127add18\r
    X-Runtime: 0.605907\r
    Strict-Transport-Security: max-age=31536000\r
    \r
    {"data":{"domain":"ruby.codes","available":true,"premium":true}}\
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
