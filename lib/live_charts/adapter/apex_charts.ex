defmodule LiveCharts.Adapter.ApexCharts do
  use LiveCharts.Adapter

  @moduledoc """
  LiveCharts adapter for ApexCharts.js

  This adapter comes with a LiveView hook and default configs to work with ApexCharts.

  All configuration options must be set under the `:options` key in the `%Chart{}`
  config. However, you do not need to set the following options in `chart.options`
  as they are automatically set from the `%Chart{}` config.

  - `options.chart.type`: Will always be determined from the `:type` key in the
    LiveCharts config.

  - `options.series`: Will always be determined from the `:series` key in the
    LiveCharts config.


  ## Configuration

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


  ## Examples

  ### Bar Chart (Simple)

  ```elixir
  LiveCharts.build(%{
    type: :bar,
    options: %{
      xaxis: %{
        categories: [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020]
      },
      dataLabels: %{enabled: false}
    },
    series: [
      %{
        data: [43, 85, 4, 76, 56, 92, 1, 46, 75, 14]
      }
    ]
  })
  ```

  ### Pie Chart (Simple)

  ```elixir
  LiveCharts.build(%{
    type: :pie,
    series: [51, 82, 48, 65],
    options: %{
      labels: ["Ali", "Saad", "Uzair", "Hassan"]
    },
  })
  ```

  ### Line Chart (Multi-series)

  ```elixir
  LiveCharts.build(%{
    type: :line,
    options: %{
      xaxis: %{
        categories: [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020]
      }
    },
    series: [
      %{
        data: [80, 100, 44, 73, 46, 74, 14, 30, 58, 90],
        name: "Ali"
      },
      %{
        data: [81, 35, 59, 37, 62, 13, 61, 90, 100, 77],
        name: "Saad"
      },
      %{
        data: [73, 33, 42, 86, 39, 95, 28, 4, 93, 41],
        name: "Uzair"
      }
    ]
  })
  ```

  ### Area Chart

  ```elixir
  LiveCharts.build(%{
    type: :area,
    options: %{
      xaxis: %{
        categories: ~w(Jan Feb Mar Apr May Jun Jul Aug Sep Nov Dec)
      },
      dataLabels: %{enabled: false},
      yaxis: %{max: 100, min: 0}
    },
    series: [
      %{
        data: [62, 53, 67, 65, 61, 64, 63, 59, 57, 70, 85, 80],
        name: "Ali"
      },
      %{
        data: [26, 41, 41, 25, 26, 21, 45, 25, 29, 48, 32, 32],
        name: "Saad"
      }
    ]
  })
  ```


  ### HeatMap Chart

  ```elixir
  LiveCharts.build(%{
    type: :heatmap,
    options: %{
      chart: %{
        height: 600
      },
      colors: ["#23700C"],
      dataLabels: %{
        enabled: false
      }
    },
    series: Enum.map(~w(Jan Feb Mar Apr May Jun Jul Aug Sep Nov Dec), fn month ->
      %{
        name: month,
        data: Enum.map(1..5, fn i ->
          %{
            x: to_string(2020 + i),
            y: random_value(min: 10, max: 80)
          }
        end)
      }
    end)
  })
  ```


  Live demos for various charts are [available here](https://livecharts.stax3.com/).
  You can also view the [source code](https://github.com/Stax3/live_charts_demo) for
  the examples in the demo. For the full list of supported options, see
  [ApexCharts documentation](https://apexcharts.com/docs/).
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
