defmodule Dnsimple.Webhooks do
  @moduledoc """
  Provides functions to interact with the
  [webhook endpoints](https://developer.dnsimple.com/v2/webhooks/).

  See:
  - https://developer.dnsimple.com/v2/webhooks/
  """

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Webhook


  @doc """
  Lists the existing webhooks in the account.

  See:
  - https://developer.dnsimple.com/v2/webhooks/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Webhooks.list_webhooks(client, account_id = "1010")

  """
  @spec list_webhooks(Client.t, String.t | integer) :: {:ok|:error, Response.t}
  def list_webhooks(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/webhooks")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Webhook{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a webhook.

  See:
  - https://developer.dnsimple.com/v2/webhooks/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Webhooks.get_webhook(client, account_id = "1010", webhook_id = 1234)

  """
  @spec get_webhook(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_webhook(client, account_id, webhook_id, options \\ []) do
    url = Client.versioned("/#{account_id}/webhooks/#{webhook_id}")

    Client.get(client, url, options)
    |> Response.parse(%{"data" => %Webhook{}})
  end


  @doc """
  Creates a new webhook.

  See:
  - https://developer.dnsimple.com/v2/webhooks/#create

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Webhooks.create_webhook(client, account_id = "1010", %{
        url: "https://test.host/handler"
      })

  """
  @spec create_webhook(Client.t, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def create_webhook(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/webhooks")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Webhook{}})
  end


  @doc """
  Deletes a webhook.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/webhooks/#delete

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Webhooks.delete_webhook(client, account_id = "1010", webhook_id = 1234)

  """
  @spec delete_webhook(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_webhook(client, account_id, webhook_id, options \\ []) do
    url = Client.versioned("/#{account_id}/webhooks/#{webhook_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
