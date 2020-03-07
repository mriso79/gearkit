defmodule Responses.Library do
  @moduledoc false
  
  def success() do
    map = %{:code => 1, :msg => "Inserted Successfully"}
  end

  def integrityFailed() do
    map = %{:code => 2, :msg => "Your post data is not complete. Make sure the collection and data fields are present"}
  end

  def filterIntegrityFailed() do
    map = %{:code => 3, :msg => "Your post data is not complete. Make sure the collection, filter and data fields are present"}
  end

  def missingLimitParameter() do
    map = %{:code => 4, :msg => "The limit parameter are missing"}
  end

  def missingSkipParameter() do
    map = %{:code => 5, :msg => "The skip parameter are missing"}
  end

  def missingCollectionParameter() do
    map = %{:code => 6, :msg => "The collection parameter are missing"}
  end

  def loginSucessful() do
    map = %{:code => 7, :msg => "Login successful"}
  end

  def errorLogin() do
    map = %{:code => 8, :msg => "Email and/or Password invalid"}
  end

  def unAuthorized() do
    map = %{:code => 9, :msg => "You are unauthorized"}
  end

  def logoutSuccessful() do
    map = %{:code => 10, :msg => "Logout successful"}
  end

end
