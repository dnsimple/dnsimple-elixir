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
  Returns the list of existing templates in the account.

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


  @doc """
  Returns a template in the account.

  See https://developer.dnsimple.com/v2/templates/#get

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.get_template(client, account_id = 1010, template_id = "alpha")

  """
  @spec get_template(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def get_template(client, account_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}")

    List.get(client, url, options)
    |> Response.parse(Template)
  end

  @spec template(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate template(client, account_id, template_id, options \\ []), to: __MODULE__, as: :get_template


  @doc """
  Creates a new template in the account.

  See https://developer.dnsimple.com/v2/templates/#create

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.create_template(client, account_id = 1010, %{
      name: "Beta",
      short_name: "beta",
      description: "A beta template.",
    })

  """
  @spec create_template(Client.t, String.t | integer, map, Keyword.t) :: Response.t
  def create_template(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/templates")

    Client.post(client, url, attributes, options)
    |> Response.parse(Template)
  end


  @doc """
  Updates an existing template.

  See https://developer.dnsimple.com/v2/templates/#update

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.update_template(client, account_id = 1010, template_id = 1, %{
      name: "Beta",
      short_name: "beta",
      description: "A beta template.",
    })

  """
  @spec update_template(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: Response.t
  def update_template(client, account_id, template_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}")

    Client.patch(client, url, attributes, options)
    |> Response.parse(Template)
  end


  @doc """
  PERMANENTLY deletes an existing template.

  See https://developer.dnsimple.com/v2/templates/#delete

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.delete_template(client, account_id = 1010, template_id = "alpha")

  """
  @spec delete_template(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def delete_template(client, account_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end

end
