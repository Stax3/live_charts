defmodule LiveCharts do
  @version Mix.Project.config()[:version]

  @moduledoc """
  LiveCharts is a library to render static and dynamic charts
  in Phoenix LiveView applications.

  ## Getting started

  Add `:live_charts` to your `mix.exs` dependencies:

    defp deps do
      [
        {:live_charts, "~> #{@version}"},
      ]
    end
  """

  @doc """
  Build a new chart config.

  See `LiveCharts.Chart.build/1` for more details.
  """
  @spec build(map()) :: LiveCharts.Chart.t()
  defdelegate build(assigns), to: LiveCharts.Chart

  @doc """
  Renders a chart component.

  See `LiveCharts.Components.chart/1` for more details.
  """
  @spec chart(map()) :: Phoenix.HTML.t()
  defdelegate chart(assigns), to: LiveCharts.Components
end
