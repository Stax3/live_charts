defmodule LiveCharts.MixProject do
  use Mix.Project

  @app :live_charts
  @name "LiveCharts"
  @version "0.2.0"
  @github "https://github.com/stax3/#{@app}"
  @author "Stax3"
  @license "MIT"

  # NOTE:
  # To publish package or update docs, use the `docs`
  # mix environment to not include support modules
  # that are normally included in the `dev` environment
  #
  #   MIX_ENV=docs mix hex.publish
  #

  def project do
    [
      # Project
      app: @app,
      version: @version,
      elixir: "~> 1.16",
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: @github
    ]
  end

  # BEAM Application
  def application do
    [
      env: default_env(),
      extra_applications: [:logger]
    ]
  end

  # Default Env
  def default_env do
    [
      adapter: LiveCharts.Adapter.ApexCharts,
      json_library: Jason
    ]
  end

  defp deps do
    [
      {:phoenix_live_view, "~> 1.0.0"},
      {:jason, "~> 1.4.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :docs},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp elixirc_paths(:dev), do: elixirc_paths(:test)
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:docs), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    "Real-time and dynamic charts in LiveView"
  end

  defp package do
    [
      name: @app,
      maintainers: [@author],
      licenses: [@license],
      files: ~w(mix.exs lib README.md),
      links: %{"GitHub" => @github}
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
        {"README.md", title: @name},
        "LICENSE"
      ],
      assets: %{
        "media" => "media"
      }
    ]
  end
end
