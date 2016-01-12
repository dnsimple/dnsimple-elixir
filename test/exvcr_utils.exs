defmodule ExvcrUtils do

  def fixture(name) do
    Path.join([__DIR__, "fixtures.http", name])
  end

  def read_fixture(name) do
    fixture(name)
    |> File.read!
  end

  def parse_fixture(content) do
    [status | lines] = String.split(content, "\n")
    [_, _, code, _] = Regex.run(~r/\AHTTP(?:\/(\d+\.\d+))?\s+(\d\d\d)\s*(.*)\z/i, status)
    [headers, body] = parse_http_headers(lines, [])

    [code, headers, body]
  end

  def response_fixture(name, options \\ []) do
    [code, headers, body] = parse_fixture(read_fixture(name))
    options ++ [body: body, headers: headers, status_code: code]
  end


  defp parse_http_headers([], accumulator) do
    [accumulator, nil]
  end

  defp parse_http_headers(["", body], accumulator) do
    [accumulator, body]
  end

  defp parse_http_headers([h|t], accumulator) do
    [key, value] = String.split(h, ~r/:\s?/, parts: 2)
    parse_http_headers(t, [{key, value}|accumulator])
  end

end

