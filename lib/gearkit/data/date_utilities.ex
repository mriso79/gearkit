defmodule Data.DateUtilities do
  @moduledoc false

  def current_date() do
    {:ok, datetimeFormat} = Calendar.DateTime.now("America/Sao_Paulo")
    unixFormat = datetimeFormat |> Calendar.DateTime.Format.js_ms
  end

end
