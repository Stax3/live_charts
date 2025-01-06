defmodule LiveCharts.ValidationError do
  @moduledoc """
  Raised when a chart fails validation
  """
  defexception [:reason, :message]

  def exception(opts) do
    reason = Keyword.fetch!(opts, :reason)
    message = opts[:message] || "chart validation failed: #{inspect(reason)}"
    %__MODULE__{message: message, reason: reason}
  end
end
