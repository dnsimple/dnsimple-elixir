defmodule Dnsimple.Templates do
  @moduledoc """
  Provides functions to interact with the
  [template endpoints](https://developer.dnsimple.com/v2/services/).

  See:
  - https://developer.dnsimple.com/v2/templates/
  - https://developer.dnsimple.com/v2/templates/records/
  - https://developer.dnsimple.com/v2/templates/domains/
  """
  @moduledoc section: :api

  alias Dnsimple.Client
  alias Dnsimple.Listing
  alias Dnsimple.Response
  alias Dnsimple.Template
  alias Dnsimple.TemplateRecord

  @doc """
  Returns the list of existing templates in the account.

  See:
  - https://developer.dnsimple.com/v2/templates/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.list_templates(client, account_id = 1010)
      {:ok, response} = Dnsimple.Templates.list_templates(client, account_id = 1010, sort: "name:asc")

  """
  @spec list_templates(Client.t, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_templates(client, account_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%Template{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a template.

  See:
  - https://developer.dnsimple.com/v2/templates/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.get_template(client, account_id = 1010, template_id = "alpha")

  """
  @spec get_template(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_template(client, account_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => %Template{}})
  end


  @doc """
  Creates a new template.

  See:
  - https://developer.dnsimple.com/v2/templates/#create

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.create_template(client, account_id = 1010, %{
        name: "Beta",
        short_name: "beta",
        description: "A beta template.",
      })

  """
  @spec create_template(Client.t, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def create_template(client, account_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/templates")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %Template{}})
  end


  @doc """
  Updates an existing template.

  See:
  - https://developer.dnsimple.com/v2/templates/#update

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.update_template(client, account_id = 1010, template_id = 1, %{
        name: "Beta",
        short_name: "beta",
        description: "A beta template.",
      })

  """
  @spec update_template(Client.t, String.t | integer, String.t | integer, map, Keyword.t) :: {:ok|:error, Response.t}
  def update_template(client, account_id, template_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}")

    Client.patch(client, url, attributes, options)
    |> Response.parse(%{"data" => %Template{}})
  end


  @doc """
  Deletes a template.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/templates/#delete

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.delete_template(client, account_id = 1010, template_id = "alpha")

  """
  @spec delete_template(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_template(client, account_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Returns the list of records in the template.

  See:
  - https://developer.dnsimple.com/v2/templates/records/#list

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.list_template_records(client, account_id = 1010, template_id = 1)
      Dnsimple.Templates.list_template_records(client, account_id = 1010, template_id = 1, sort: "type:asc")

  """
  @spec list_template_records(Client.t, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def list_template_records(client, account_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => [%TemplateRecord{}], "pagination" => %Response.Pagination{}})
  end


  @doc """
  Returns a record of the template.

  See:
  - https://developer.dnsimple.com/v2/templates/records/#get

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.get_template_record(client, account_id = 1010, template_id = "alpha", record_id = 123)

  """
  @spec get_template_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def get_template_record(client, account_id, template_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records/#{record_id}")

    Listing.get(client, url, options)
    |> Response.parse(%{"data" => %TemplateRecord{}})
  end


  @doc """
  Creates a new record in the template.

  See:
  - https://developer.dnsimple.com/v2/templates/records/#create

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.create_template_record(client, account_id = 1010, template_id = "alpha" %{
        name: "",
        type: "mx",
        content: "mx.example.com",
        ttl: 600,
        prio: 10,
      })

  """
  @spec create_template_record(Client.t, String.t | integer, String.t | integer, map,  Keyword.t) :: {:ok|:error, Response.t}
  def create_template_record(client, account_id, template_id, attributes, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records")

    Client.post(client, url, attributes, options)
    |> Response.parse(%{"data" => %TemplateRecord{}})
  end


  @doc """
  Deletes a record from a template.

  **Warning**: this is a destructive operation.

  See:
  - https://developer.dnsimple.com/v2/templates/records/#delete

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.delete_template_record(client, account_id = 1010, template_id = "alpha", record_id = 1)

  """
  @spec delete_template_record(Client.t, String.t | integer, String.t | integer, integer, Keyword.t) :: {:ok|:error, Response.t}
  def delete_template_record(client, account_id, template_id, record_id, options \\ []) do
    url = Client.versioned("/#{account_id}/templates/#{template_id}/records/#{record_id}")

    Client.delete(client, url, options)
    |> Response.parse(nil)
  end


  @doc """
  Applies a template to a domain.

  See:
  - https://developer.dnsimple.com/v2/templates/domains/#apply

  ## Examples:

      client = %Dnsimple.Client{access_token: "a1b2c3d4"}
      {:ok, response} = Dnsimple.Templates.apply_template(client, account_id = 1010, domain_id = "example.com", template_id = "alpha")

  """
  @spec apply_template(Client.t, String.t | integer, String.t | integer, String.t | integer, Keyword.t) :: {:ok|:error, Response.t}
  def apply_template(client, account_id, domain_id, template_id, options \\ []) do
    url = Client.versioned("/#{account_id}/domains/#{domain_id}/templates/#{template_id}")

    Client.post(client, url, Client.empty_body(), options)
    |> Response.parse(nil)
  end

end
