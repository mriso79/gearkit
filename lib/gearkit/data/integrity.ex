defmodule Data.Integrity do
  @moduledoc false
  
  def assertDataIntegrity(params) do
    Map.has_key?(params, "collection")
    Map.has_key?(params, "data")
  end

  def assertFilterIntegrity(params) do
    Map.has_key?(params, "collection")
    Map.has_key?(params, "filter")

  end

  def assertCollectionParameter(params) do
   Map.has_key?(params, "collection")
  end

end
