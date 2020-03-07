defmodule Security.Checker do
  @moduledoc false

  def checkAuth(jwt_string) do
    JsonWebToken.verify(jwt_string, %{key: Application.get_env(:Gearkit, :spKey)[:value]})
  end


end
