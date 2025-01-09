defmodule LiveCharts do
  @moduledoc """
  LiveCharts is a library to render static and dynamic charts
  in Phoenix LiveView applications.

  To get started, see the [README](https://hexdocs.pm/live_charts).

  LiveCharts currently comes with support for
  [ApexCharts](https://apexcharts.com/) out of the box, but it
  can work with any JS charting library that has a
  `LiveCharts.Adapter` defined.
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

  See `LiveCharts.Components.push_update/3` for more details.
  """
  defdelegate push_update(socket, chart_id, new_data), to: LiveCharts.Components
end
