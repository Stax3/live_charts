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
  defdelegate build(assigns), to: LiveCharts.Chart

  @doc """
  Renders a chart component.

  See `LiveCharts.Components.chart/1` for more details.
  """
  defdelegate chart(assigns), to: LiveCharts.Components

  @doc """
  Push a data update event to LiveView.

  See `LiveCharts.Components.push_update/2` for more details.
  """
  defdelegate push_update(socket, chart_id, new_data), to: LiveCharts.Components
end
