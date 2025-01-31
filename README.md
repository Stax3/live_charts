LiveCharts
==========

> LiveCharts allows you to render static and dynamic charts in Phoenix LiveView applications.

LiveCharts currently comes with support for [ApexCharts][apexcharts] out of the box, but it
can work with any JS charting library that has a [`LiveCharts.Adapter`][docs-adapter] defined.

To see live demos, visit: [livecharts.stax3.com][demos].



## Installation

Add `:live_charts` to your `mix.exs` dependencies:

```elixir
defp deps do
  [
    {:live_charts, "~> 0.3.0"},
  ]
end
```

Then include the LiveCharts hooks in your `app.js`:

```javascript
// Import the JS file
import LiveCharts from "live_charts"

// Include the hooks
let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: {
    // your other hooks...
    // e.g. SomeCustomHook,

    // Expand LiveCharts hooks at the end
    ...LiveCharts.Hooks,
  },
});
```



## Configuration

LiveCharts may optionally be configured to set the default adapter or JSON encoding library.
It currently defaults to the following:

```elixir
# config/config.exs

config :live_charts,
  adapter: LiveCharts.Adapter.ApexCharts,
  json_library: Jason
```



## Usage

### Chart data

LiveCharts tracks a chart's data and configuration in a [`%Chart{}`][docs-chart] struct.
Before it can be rendered, you need to build this struct.

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
    type: :bar,

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

For a full list of options, see the official [ApexCharts docs][apexcharts-docs] and
the [`LiveCharts.Adapter.ApexCharts`][docs-apex] adapter information on HexDocs.
You can also [view live demos][demos] here.


### Render Static Charts

With a `LiveCharts.Chart` struct defined, you can now `assign` it in your liveview:

```elixir
def mount(_params, _session, socket) do
  socket =
    socket
    |> assign(:page_title, "Page with charts!")
    |> assign(:my_chart, my_chart)

  {:ok, socket}
end
```

To then render the chart in a heex template, use `LiveCharts.chart/1` component:

```elixir
<LiveCharts.chart chart={@my_chart} />
```

This will re-render the chart on the page any time the `chart` assign is changed or updated.


### Push Realtime/Dynamic updates to the Chart

If the chart needs to be updated often, a better strategy is to only push the new data instead
of rebuilding the entire chart and re-rendering it. You can do so by calling:

```elixir
LiveCharts.push_update(socket, chart.id, updated_series)
```

## Example

Let's say we want to render a line chart that starts out empty, but as we get datapoints from
an external source, we want to push them to the users' browsers.

We'll start by assigning a line chart to the LiveView:

```elixir
@impl true
def mount(_params, _session, socket) do
  # Build an empty chart with custom settings
  chart = LiveCharts.build(%{
    type: :line,
    series: [],
    options: %{
      xaxis: %{type: "datetime"},
      yaxis: %{min: 0, max: 100},
      chart: %{
        animations: %{enabled: true, easing: "linear"},
        zoom: %{enabled: false}
      }
    }
  })

  socket =
    socket
    |> assign(:chart, chart)
    |> assign(:chart_data, [])

  {:ok, socket}
end
```

Then, render the empty chart in your heex template:

```elixir
<LiveCharts.chart chart={@chart} />
```

Assuming you already have a mechanism in place to receive new data points in the liveview, you
can then update the chart data and push it over the socket:

```elixir
@impl true
def handle_info({:chart_datapoint, {x, y}}, socket) do
  %{chart: chart, chart_data: data} = socket.assigns

  data = [%{x: x, y: y} | data]
  series = [%{data: Enum.reverse(data)}]

  socket =
    socket
    |> assign(:chart_data, data)
    |> LiveCharts.push_update(chart, series)

  {:noreply, socket}
end
```

We have used `handle_info/2` here, but chart updates could just as easily be pushed from other
liveview callbacks. E.g. from `handle_event/3` when the user triggers an event or
`handle_async/3` when an async task is completed.

A live demo is also available on [livecharts.stax3.com][demos].



## Looking for help with your Elixir project?

[Stax3][stax3] helps startups craft expressive and engaging solutions for their software needs.
If you're looking for expertise for your Elixir/Phoenix projects, we can help! Talk to us at
[contact@stax3.com][email].



## License

LiveCharts is licensed under the [MIT License][license].




[license]:          https://opensource.org/license/mit
[hexpm]:            https://hex.pm/packages/live_charts
[apexcharts]:       https://apexcharts.com
[apexcharts-docs]:  https://apexcharts.com/docs/
[demos]:            https://livecharts.stax3.com/
[stax3]:            https://stax3.com
[email]:            mailto:contact@stax3.com

[docs]:             https://hexdocs.pm/live_charts
[docs-chart]:       https://hexdocs.pm/live_charts/LiveCharts.Chart.html
[docs-adapter]:     https://hexdocs.pm/live_charts/LiveCharts.Adapter.html
[docs-apex]:        https://hexdocs.pm/live_charts/LiveCharts.Adapter.ApexCharts.html
