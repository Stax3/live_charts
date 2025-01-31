defmodule LiveCharts.MixProject do
  use Mix.Project

  @app :live_charts
  @name "LiveCharts"
  @version "0.3.0"
  @github "https://github.com/stax3/#{@app}"
  @author "Stax3"
  @license "MIT"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.16",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: @github
    ]
  end

  def application do
    [
      env: default_config(),
      extra_applications: [:logger]
    ]
  end

  def default_config do
    [
      adapter: LiveCharts.Adapter.ApexCharts,
      json_library: Jason
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0.0"},
      {:jason, "~> 1.4.0", optional: true},
      {:esbuild, "~> 0.8.0", only: :dev},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :dev}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Real-time and dynamic charts in LiveView"
  end

  defp package do
    [
      name: @app,
      maintainers: [@author],
      licenses: [@license],
      links: %{"GitHub" => @github},
      files: ~w(
        mix.exs
        package.json
        lib
        priv
        assets/js
        README.md
      )
    ]
  end

  defp docs do
    [
      name: @name,
      main: "readme",
      source_url: @github,
      source_ref: "v#{@version}",
      canonical: "https://hexdocs.pm/#{@app}",
      extras: [
        {"README.md", title: @name}
      ],
      assets: %{
        "media" => "media"
      }
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "cmd --cd assets npm install"],
      "assets.build": ["esbuild module", "esbuild cdn", "esbuild cdn_min", "esbuild main"],
      "assets.watch": ["esbuild module --watch"]
    ]
  end
end
