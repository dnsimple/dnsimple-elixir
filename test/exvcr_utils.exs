defmodule ExvcrUtils do

  def fixture(name) do
    Path.join([__DIR__, "fixtures.http", name])
  end

  def read_fixture(name) do
    fixture(name)
    |> File.read!
  end

  def response_fixture(name, options \\ []) do
    [status_code, headers, body] = parse_fixture(read_fixture(name))
    options ++ [body: body, headers: headers, status_code: status_code ]
  end

  def parse_fixture(content) do
    [ status, headers, body ] = break_into_parts(content)
    [ extract_code(status), extract_headers(headers), body]
  end

  def break_into_parts(content) do
    [head, body]      = String.split(content, "\n\n")
    [status, headers] = String.split(head, "\n", parts: 2)
    [status, headers, body]
  end

  def extract_code(status_line) do
    [_, _, code, _] = Regex.run(~r/\AHTTP(?:\/(\d+\.\d+))?\s+(\d\d\d)\s*(.*)\z/i, status_line)
    String.to_integer(code)
  end

  def extract_headers(headers_lines) do
    String.split(headers_lines, "\n")
      |> Enum.map(fn(line) -> String.split(line, ~r{:\s?}, parts: 2) end)
      |> List.foldr(%{}, fn([key, value], headers) -> Map.put(headers, key, value) end)
  end

end
