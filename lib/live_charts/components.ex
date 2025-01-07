defmodule LiveCharts.Components do
  use Phoenix.Component

  alias LiveCharts.Chart
  alias Phoenix.LiveView
  alias Phoenix.LiveView.Socket

  @doc """
  Render a chart in LiveView.
  """

  attr :chart, Chart, required: true, doc: "A %Chart{} configuration"

  @spec chart(map()) :: Phoenix.HTML.t()
  def chart(%{chart: chart} = assigns) do
    LiveCharts.Validator.validate!(chart)

    assigns =
      assigns
      |> assign(:html_data, Chart.html_data(chart))
      |> assign(:hook, Chart.hook(chart))

    ~H"""
    <div id={@chart.id} data-chart={@html_data} phx-hook={@hook}></div>
    """
  end

  @doc """
  Push an update event on the LiveView socket to update
  chart data.
  """
  @spec push_update(Socket.t(), String.t() | Chart.t(), [Chart.series()]) :: Socket.t()
  def push_update(%Socket{} = socket, %Chart{id: id}, data) do
    push_update(socket, id, data)
  end

  def push_update(%Socket{} = socket, id, data) when is_binary(id) do
    LiveView.push_event(socket, "live-charts:update:#{id}", %{data: data})
  end
end
