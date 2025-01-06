defmodule LiveCharts.Components do
  use Phoenix.Component

  @doc """
  Render a chart in LiveView.
  """

  attr :chart, LiveCharts.Chart, required: true, doc: "A %Chart{} configuration"

  @spec chart(map()) :: Phoenix.HTML.t()
  def chart(%{chart: chart} = assigns) do
    LiveCharts.Validator.validate!(chart)

    assigns =
      assigns
      |> assign(:html_data, LiveCharts.Chart.html_data(chart))
      |> assign(:hook, LiveCharts.Chart.hook(chart))

    ~H"""
    <div id={@chart.id} data-chart={@html_data} phx-hook={@hook}></div>
    """
  end
end
