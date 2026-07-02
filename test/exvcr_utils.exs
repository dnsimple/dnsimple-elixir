defmodule ExvcrUtils do
  def fixture(name) do
    Path.join([__DIR__, "fixtures.http", name])
  end

  def read_fixture(name) do
    fixture(name)
    |> File.read!()
  end

  def response_fixture(name, options \\ []) do
    [status_code, headers, body] = parse_fixture(read_fixture(name))
    options ++ [body: body, headers: headers, status_code: status_code]
  end

  @doc """
  Reads an .http fixture and writes it as a response on the given `Plug.Conn`.
  Used from Bypass expectations to serve the pre-recorded response.
  """
  def respond_with_fixture(conn, name) do
    [status_code, headers, body] = parse_fixture(read_fixture(name))

    conn =
      Enum.reduce(headers, conn, fn {k, v}, c -> Plug.Conn.put_resp_header(c, k, v) end)

    Plug.Conn.resp(conn, status_code, body)
  end

  def parse_fixture(content) do
    [status, headers, body] = break_into_parts(content)
    [extract_code(status), extract_headers(headers), body]
  end

  def break_into_parts(content) do
    [head, body] = String.split(content, ~r{\n\n|\r\n\r\n})
    [status, headers] = String.split(head, "\n", parts: 2)
    [status, headers, body]
  end

  def extract_code(status_line) do
    [_, _, code, _] = Regex.run(~r/\AHTTP(?:\/(\d+\.\d+))?\s+(\d\d\d)\s*(.*)\z/i, status_line)
    String.to_integer(code)
  end

  def extract_headers(headers_lines) do
    String.split(headers_lines, ~r{\r?\n})
    |> Enum.map(&header_line_to_key_value_pair/1)
    |> Enum.into(%{})
  end

  defp header_line_to_key_value_pair(line) do
    String.split(line, ~r{:\s?}, parts: 2)
    |> List.to_tuple()
  end
end
