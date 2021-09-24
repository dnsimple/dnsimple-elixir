defmodule Dnsimple.Mixfile do
  use Mix.Project

  @source_url "https://github.com/dnsimple/dnsimple-elixir"
  @version "3.0.2"

  def project do
    [app: :dnsimple,
     version: @version,
     elixir: "~> 1.8",
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
      {:httpoison, "~> 1.0"},
      {:poison, ">= 2.0.0"},
      {:exvcr, "~> 0.13.2", only: :test},
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
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end
end
