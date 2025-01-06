defmodule LiveCharts.Adapter.ApexCharts do
  use LiveCharts.Adapter

  @moduledoc """
  LiveCharts adapter for ApexCharts.js

  This adapter comes with a LiveView hook and default configs
  to work with ApexCharts.

  All configuration options must be set under the `:options`
  key in the `%Chart{}` config. However, you do not need to
  set the following options in `chart.options` as they are
  automatically set from the `%Chart{}` config.

  - `options.chart.type`: Will always be determined from the
    `:type` key in the LiveCharts config.
  - `options.series`: Will always be determined from the
    `:series` key in the LiveCharts config.

  ## Example

    chart = LiveCharts.build(%{
      type: :bar,
      series: [
        %{name: "Sales", data: [10, 20, 30, 40, 50]}
      ],
      options: %{
        xaxis: %{
          categories: [2021, 2022, 2023, 2024, 2025]
        }
      }
    })


  For the full list of supported options, see
  [ApexCharts docs](https://apexcharts.com/docs/).
  """

  @impl true
  def hook(_type) do
    "LiveCharts.Hooks.ApexCharts"
  end

  @impl true
  def build_config(%LiveCharts.Chart{} = chart) do
    options = Map.drop(chart.options, [:chart, :series])

    default_options()
    |> Map.merge(options)
    |> Map.merge(%{
      chart:
        chart.options
        |> Map.get(:chart, default_options(:chart))
        |> Map.put(:type, chart.type),
      series: chart.series
    })
  end

  defp default_options do
    %{noData: %{text: "Loading..."}}
  end

  defp default_options(:chart) do
    %{height: "100%", width: "100%"}
  end
end
