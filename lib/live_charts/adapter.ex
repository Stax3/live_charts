defmodule LiveCharts.Adapter do
  @moduledoc """
  LiveCharts adapter specification.

  Adapter is a module that translates `%LiveCharts.Chart{}` struct
  into a JS charting library specific configuration. It will usually
  expose a LiveView hook to handle dynamic data updates as well.

  Right now, LiveCharts ships with only one adapter:
  `LiveCharts.Adapter.ApexCharts` (default).

  ## Example

  To define a new adapter for your favorite JS charting library, or
  override the Hook or options, you must call `use LiveCharts.Adapter`
  and implement the required callbacks.

  ```elixir
  defmodule MyCustomChartAdapter do
    use LiveCharts.Adapter

    @impl true
    def hook, do: "MyCustomChartHook"

    @impl true
    def build_config(%Chart{} = chart) do
      # return a plain map representing the JS library config
      # that should be passed to the hook

      %{
        my_js_lib: %{
          chart_type: chart.type,
          chart_data: chart.data,
          # ...
        }
      }
    end
  end
  ```
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour LiveCharts.Adapter

      def implements, do: LiveCharts.Adapter
    end
  end

  @doc """
  Fully qualified name of the LiveView hook to call when rendering
  the chart.
  """
  @callback hook(LiveCharts.Chart.t()) :: String.t()

  @doc """
  Translate a `%Chart{}` struct to JS library-specific options
  """
  @callback build_config(LiveCharts.Chart.t()) :: map()
end
