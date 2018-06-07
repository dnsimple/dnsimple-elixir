defmodule Dnsimple.Mixfile do
  use Mix.Project

  def project do
    [app: :dnsimple,
     version: "1.2.0",
     elixir: ">= 1.4.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     description: description(),
     deps: deps(),
     dialyzer: [plt_add_deps: :transitive]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, ">= 0.13.0"},
      {:poison, ">= 2.0.0"},
      {:exvcr, "~> 0.10.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "*.md"],
      maintainers: ["Simone Carletti", "Javier Acero", "Anthony Eden"],
      licenses: ["MIT"],
      links: %{
        "GitHub"      => "https://github.com/dnsimple/dnsimple-elixir",
        "API v2 docs" => "https://developer.dnsimple.com/v2",
      }
    ]
  end

  defp description do
    """
    Elixir client for the DNSimple API v2.
    """
  end

end
