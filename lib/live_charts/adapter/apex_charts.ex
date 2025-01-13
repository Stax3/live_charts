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

  ```elixir
  my_chart =
    LiveCharts.build(%{
      # (Optional) a unique string id to differentiate the chart from other
      # charts on the same page. If not set, a random id will be assigned
      # to the chart.
      id: "my-custom-chart-id",

      # Set the chart type. Supports `:line`, `:bar`, `:pie`, `:donut`,
      # `:area`, and many more. For a full list of supported types, see the
      # adapter or JS library documentation.
      type: :line,

      # A list of series data with all the datapoints to chart. Format of
      # this data is determined by the adapter/JS library. This may also
      # be empty, if you plan to push dynamic updates to the chart over
      # the socket later.
      series: [
        %{name: "Sales", data: [10, 20, 30, 40, 50]},
      ],

      # (Optional) Other library and adapter-specific options.
      options: %{
        xaxis: %{
          categories: [2021, 2022, 2023, 2024, 2025]
        },
      },

      # (Optional) set the adapter to use for the chart. If not set, uses
      # the global adapter configured in `config.exs` (defaults to
      # `LiveCharts.Adapter.ApexCharts`).
      adapter: LiveCharts.Adapter.ApexCharts,
    })
  ```

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
        |> Map.put(:type, chart.type)
        |> Map.put(:id, chart.id),
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
