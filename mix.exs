defmodule Dnsimple.Mixfile do
  use Mix.Project

  @source_url "https://github.com/dnsimple/dnsimple-elixir"
  @version "4.0.0"

  def project do
    [app: :dnsimple,
     version: @version,
     elixir: "~> 1.12",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps(),
     docs: docs(),
     dialyzer: [plt_add_deps: :transitive]
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
      {:exvcr, "~> 0.15.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      description: "Elixir client for the DNSimple API v2.",
      files: ["lib", "mix.exs", "*.md"],
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
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"],
      ],
      groups_for_modules: [
        "API": & &1[:section] == :api,
        "Data Types": & &1[:section] == :data_types,
        "Util": & &1[:section] == :util
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
