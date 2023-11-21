defmodule Dnsimple.Billing do
  @moduledoc """
  Provides functions to interact with the
  [billing endpoints](https://developer.dnsimple.com/v2/billing/).
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Charge
  alias Dnsimple.Response

  @doc """
  Lists the billing charges the current authenticated entity has access to.

  See:
  - https://developer.dnsimple.com/v2/billing/#listCharges

  Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Billing.list_charges(client, account_id = "1010")
      {:ok, response} = Dnsimple.Billing.list_charges(client, account_id = "1010", filter: [start_date: "2016-01-01", end_date: "2016-01-31"])
      {:ok, response} = Dnsimple.Billing.list_charges(client, account_id = "1010", page: 2, per_page: 10)
      {:ok, response} = Dnsimple.Billing.list_charges(client, account_id = "1010", sort: "invoiced:asc")

  """
  @spec list_charges(Client.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_charges(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/billing/charges")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Charge{}], "pagination" => %Response.Pagination{}})
  end
end
