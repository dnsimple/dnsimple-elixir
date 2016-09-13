defmodule Dnsimple.Templates do
  @moduledoc """
  This module provides functions to interact with the template related endpoints.

  See: https://developer.dnsimple.com/v2/templates/
  """

  alias Dnsimple.List
  alias Dnsimple.Client
  alias Dnsimple.Response
  alias Dnsimple.Template
  alias Dnsimple.TemplateRecord

  @doc """
  Returns the list of existing templates in the account.

  See https://developer.dnsimple.com/v2/templates/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.list_templates(client, account_id = 1010)
    Dnsimple.Templates.list_templates(client, account_id = 1010, sort: "name:asc")

  """
  @spec list_templates(Client.t, String.t | integer, Keyword.t) :: Response.t
  def list_templates(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates")

    List.get(client, url, options)
    |> Response.parse(%{"data" => [%Template{}], "pagination" => %Response.Pagination{}})
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
    |> Response.parse(%{"data" => %Template{}})
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
    |> Response.parse(%{"data" => %Template{}})
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
    |> Response.parse(%{"data" => %Template{}})
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


  @doc """
  Returns the list of records in the  template.

  See https://developer.dnsimple.com/v2/templates/records/#list

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.list_template_records(client, account_id = 1010, template_id = 1)
    Dnsimple.Templates.list_template_records(client, account_id = 1010, template_id = 1, sort: "type:asc")

  """
  @spec list_template_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def list_template_records(client, account_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records")

    List.get(client, url, options)
    |> Response.parse(%{"data" => [%TemplateRecord{}], "pagination" => %Response.Pagination{}})
  end

  @spec template_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  defdelegate template_records(client, account_id, template_id, options \\ []), to: __MODULE__, as: :list_template_records


  @doc """
  Returns a record in of the template.

  See https://developer.dnsimple.com/v2/templates/records/#get

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.get_template_record(client, account_id = 1010, template_id = "alpha", record_id = 123)

  """
  @spec get_template_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  def get_template_record(client, account_id, template_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records/#{record_id}")

    List.get(client, url, options)
    |> Response.parse(%{"data" => %TemplateRecord{}})
  end

  @spec template_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  defdelegate template_record(client, account_id, template_id, record_id, options \\ []), to: __MODULE__, as: :get_template_record


  @doc """
  Creates a new record in the template.

  See https://developer.dnsimple.com/v2/templates/records/#create

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.create_template_record(client, account_id = 1010, template_id = "alpha" %{
      name: "",
      type: "mx",
      content: "mx.example.com",
      ttl: 600,
      prio: 10,
    })

  """
  @spec create_template_record(Client.t, String.t | integer, String.t | integer, map,  Keyword.t) :: Response.t
  def create_template_record(client, account_id, template_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %TemplateRecord{}})
  end


  @doc """
  PERMANENTLY deletes a record from the template.

  See https://developer.dnsimple.com/v2/templates/records/#delete

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.delete_template_record(client, account_id = 1010, template_id = "alpha", record_id = 1)

  """
  @spec delete_template_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: Response.t
  def delete_template_record(client, account_id, template_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records/#{record_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Applies a template to a domain.

  See https://developer.dnsimple.com/v2/templates/domains/#apply

  ## Examples:

    client = %Dnsimple.Client{access_token: "a1b2c3d4"}

    Dnsimple.Templates.apply_template(client, account_id = 1010, domain_id = "example.com", template_id = "alpha")

  """
  @spec apply_template(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: Response.t
  def apply_template(client, account_id, domain_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/templates/#{template_id}")

    Client.post(client, url, Client.empty_body, options)
    |> Response.parse(nil)
  end

end
