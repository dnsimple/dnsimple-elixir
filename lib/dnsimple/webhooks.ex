defmodule Dnsimple.Webhooks do
  @moduledoc """
  WebhooksService handles communication with webhook related
  methods of the DNSimple API.

  See https://developer.dnsimple.com/v2/webhooks/
  """

  alias Dnsimple.Client
  alias Dnsimple.ListOptions
  alias Dnsimple.Response
  alias Dnsimple.Webhook


  @doc """
  Lists the webhooks.

  See https://developer.dnsimple.com/v2/webhooks/#list
  """
  @spec webhooks(Client.t, String.t | integer) :: Response.t
  def webhooks(client, account_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/webhooks"), headers, ListOptions.prepare(opts))
    |> Response.parse(Webhook)
  end

  @doc """
  Creates a new webhook in the account.

  See https://developer.dnsimple.com/v2/webhooks/#create
  """
  @spec create_webhook(Client.t, String.t | integer, map, Keyword.t) :: Response.t
  def create_webhook(client, account_id, attributes, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.post(client, Client.versioned("/#{account_id}/webhooks"), attributes, headers, opts)
    |> Response.parse(Webhook)
  end

  @doc """
  Get a webhook.

  See https://developer.dnsimple.com/v2/webhooks/#get
  """
  @spec webhook(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def webhook(client, account_id, webhook_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.get(client, Client.versioned("/#{account_id}/webhooks/#{webhook_id}"), headers, opts)
    |> Response.parse(Webhook)
  end

  @doc """
  PERMANENTLY deletes a webhook from the account.

  See https://developer.dnsimple.com/v2/webhooks/#delete
  """
  @spec delete_webhook(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_webhook(client, account_id, webhook_id, options \\ []) do
    {headers, opts} = Client.headers(options)
    Client.delete(client, Client.versioned("/#{account_id}/webhooks/#{webhook_id}"), headers, opts)
    |> Response.parse(nil)
  end
end
