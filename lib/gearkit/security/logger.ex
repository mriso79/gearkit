defmodule Security.Logger do
  @moduledoc """
    This module saves a log information for the transaction
  """

  def saveLog(action, user, payload) do
    params = %{"data" => %{"action"=> action, "user"=> user, "payload"=>payload}, "collection" => "logs"}
    Data.Interface.insertLog(params)
  end


end
