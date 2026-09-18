defmodule Dnsimple.DnsAnalytics do
  @moduledoc """
  Provides functions to interact with the
  [DNS Analytics endpoints](https://developer.dnsimple.com/v2/dns-analytics/).

  The DNS Analytics API is in Public Beta.
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.DnsAnalyticsRow
  alias Dnsimple.Listing
  alias Dnsimple.Response

  @doc """
  Queries the DNS Analytics data of the account.

  The response `data` is a list of `Dnsimple.DnsAnalyticsRow`. The response `query` contains the parameters that produced the result.

  See:
  - https://developer.dnsimple.com/v2/dns-analytics/#queryDnsAnalytics

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.DnsAnalytics.query(client, account_id = 1010)
      {:ok, response} = Dnsimple.DnsAnalytics.query(client, account_id = 1010, filter: [start_date: "2023-12-01", end_date: "2023-12-31"])
      {:ok, response} = Dnsimple.DnsAnalytics.query(client, account_id = 1010, groupings: "zone_name,date")
      {:ok, response} = Dnsimple.DnsAnalytics.query(client, account_id = 1010, sort: "volume:desc,zone_name:asc")
      {:ok, response} = Dnsimple.DnsAnalytics.query(client, account_id = 1010, page: 2, per_page: 10)

  """
  @spec query(Client.t(), String.t() | integer, Keyword.t()) :: {:ok | :error, Response.t()}
  def query(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/dns_analytics")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => nil, "pagination" => %Response.Pagination{}, "query" => nil})
    |> build_rows()
  end

  defp build_rows({:ok, %Response{data: %{"headers" => headers, "rows" => rows}} = response}) do
    {:ok, %{response | data: Enum.map(rows, &build_row(headers, &1))}}
  end

  defp build_rows(error), do: error

  defp build_row(headers, values) do
    row = headers |> Enum.zip(values) |> Map.new()
    %DnsAnalyticsRow{zone_name: row["zone_name"], date: row["date"], volume: row["volume"]}
  end
end
