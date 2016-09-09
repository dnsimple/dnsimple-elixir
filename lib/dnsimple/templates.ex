defmodule Dnsimple.Templates do
  @moduledoc """
  This module provides functions to interact with the template related endpoints.

  See: https://developer.dnsimple.com/v2/templates/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Template

  @doc """
  Lists the existing templates in the account.

  See https://developer.dnsimple.com/v2/templates/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.list_templates(client, account_id = 1010)

  """
  @spec list_templates(Client.t, String.t | integer, Keyword.t) :: Response.t
  def list_templates(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates")

    List.get(client, url, options)
    |> Response.parse(Template)
  end

  @spec templates(Client.t, String.t | integer, Keyword.t) :: Response.t
  defdelegate templates(client, account_id, options \\ []), to: __MODULE__, as: :list_templates

end
