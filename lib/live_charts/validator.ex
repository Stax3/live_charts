defmodule LiveCharts.Validator do
  @moduledoc """
  Chart validation helpers
  """

  alias LiveCharts.Chart

  @doc """
  Validate a chart.

  Returns `{:ok, chart}` if chart is valid. Otherwise,
  returns `{:error, reason}`.
  """
  @spec validate(Chart.t()) :: {:ok, Chart.t()} | {:error, atom()}
  def validate(%Chart{} = chart) do
    cond do
      not is_binary(chart.id) ->
        {:error, :invalid_id}

      chart.adapter.implements() != LiveCharts.Adapter ->
        {:error, :invalid_adapter}

      true ->
        {:ok, chart}
    end
  end

  @doc """
  Validate a chart, raising an error if it is invalid.
  """
  @spec validate!(Chart.t()) :: :ok
  def validate!(chart) do
    case validate(chart) do
      {:ok, _} -> :ok
      {:error, reason} -> raise(LiveCharts.ValidationError, reason: reason)
    end
  end
end
