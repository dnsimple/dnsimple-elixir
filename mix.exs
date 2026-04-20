defmodule Dnsimple.Mixfile do
  use Mix.Project

  @source_url "https://github.com/dnsimple/dnsimple-elixir"
  @version "8.3.0"

  def project do
    [
      app: :dnsimple,
      version: @version,
      elixir: "~> 1.13",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      aliases: aliases(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:decimal, "~> 2.0"},
      {:httpoison, "~> 2.1"},
      {:poison, ">= 2.0.0"},
      {:exvcr, "~> 0.17.0", only: :test},
      ## static analysis
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
    ]
  end

  defp aliases() do
    [
      static_analysis: [
        "hex.audit",
        "compile --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "dialyzer",
        "docs"
      ]
    ]
  end

  defp package do
    [
      description: "Elixir client for the DNSimple API v2.",
      files: ["lib", "mix.exs", "*.md", "LICENSE.txt"],
      maintainers: ["Simone Carletti", "Javier Acero", "Anthony Eden"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url,
        "API v2 docs" => "https://developer.dnsimple.com/v2"
      }
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "CONTRIBUTING.md": [title: "Contributing"],
        "LICENSE.txt": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      groups_for_modules: [
        API: &(&1[:section] == :api),
        "Data Types": &(&1[:section] == :data_types),
        Util: &(&1[:section] == :util)
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
