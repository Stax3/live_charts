defmodule LiveCharts.Chart do
  @moduledoc """
  Chart struct representing initial chart data
  and configuration.

  To create a new `%Chart{}`, you should use the
  `build/1` method.
  """

  alias __MODULE__

  defstruct [
    :id,
    :type,
    series: [],
    options: %{},
    adapter: nil
  ]

  @typedoc "Chart series type"
  @type series :: map()

  @typedoc "Chart config type"
  @type t() :: %Chart{
          id: String.t(),
          type: atom(),
          series: [series()],
          options: map(),
          adapter: atom()
        }

  @doc """
  Create a new `%LiveCharts.Chart{}` struct
  """
  @spec build(map()) :: t()
  def build(%{type: _} = params) do
    default_adapter = Application.fetch_env!(:live_charts, :adapter)

    %Chart{adapter: default_adapter}
    |> struct(params)
    |> Map.update!(:id, fn
      nil -> build_id()
      id -> id
    end)
  end

  # Internal Methods

  @doc false
  @id_length 16
  def build_id do
    @id_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end

  @doc false
  def html_data(%Chart{} = chart) do
    json_library = Application.fetch_env!(:live_charts, :json_library)

    chart
    |> build_config()
    |> json_library.encode!()
  end

  @doc false
  def hook(%Chart{} = chart), do: chart.adapter.hook(chart)

  @doc false
  def build_config(%Chart{} = chart), do: chart.adapter.build_config(chart)
end
