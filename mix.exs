defmodule Dnsimple.Mixfile do
  use Mix.Project

  @source_url "https://github.com/dnsimple/dnsimple-elixir"
  @version "9.0.0"

  def project do
    [
      app: :dnsimple,
      version: @version,
      elixir: "~> 1.19",
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
      {:decimal, "~> 3.0"},
      {:httpoison, "~> 3.0"},
      {:bypass, "~> 2.1", only: :test},
      ## static analysis
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases() do
    [
      static_analysis: [
        "deps.audit",
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
