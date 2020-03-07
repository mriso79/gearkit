defmodule GearkitWeb.CrudController do
  use GearkitWeb, :controller

  @doc """
    ## Create an item in a collection
    Request example: POST to /api/v1/create
    {
      "collection": "ingredients",
      "data":{
        "name":"wheat flour",
        "price": 2.50,
        "quantity": 20,
        "unit": "kg"
        }
    }
  """
  def create(conn, params) do
    msg = Data.Interface.insert(params, Enum.at(checkJwtangReturnUser(conn),0))
    logAction(conn, "create", params["data"])
    json conn, msg
  end

  @doc """
    ## Update many items in a collection that match a filter
    Request example: POST to /api/v1/update
    {
      "collection": "pizzas",
      "filter":{
        "name": "portuguese",
        "price": 12.51
      },
      "data":{
        "name":"portuguese",
        "price": 14.90
      }
    }
  """
  def updateMany(conn, params) do
    result = Data.Interface.updateMany(params)
    logAction(conn, "updateMany", params["filter"])
    json conn, result
  end

  @doc """
    ## Update one item in a collection that match an _ID
    Request example: POST to /api/v1/update/59f918e207f83134cc9ea455
    {
      "collection": "pizzas",
      "data":{
        "name":"mozzarella",
        "price": 12.10
      }
    }
  """
  def updateOne(conn, params) do
    result = Data.Interface.updateOne(params)
    logAction(conn, "updateOne", Json.Utils.toObjectid(params["id"]))
    json conn, result
  end

  @doc """
    ## Delete using Filter
    Request example /api/v1/delete
    {
      "collection": "pizzas",
      "filter":{
        "name": "portuguese",
        "price": 14.9
      }
    }
  """
  def deleteMany(conn, params) do
    result = Data.Interface.deleteMany(params)
    logAction(conn, "deleteMany", params["filter"])
    json conn, result
  end

  @doc """
    ## Delete one record by ID
    Request example /api/v1/delete/59fd237c07f8314f0e8133ed
    {
      "collection": "pizzas"
    }
  """
  def deleteOne(conn, params) do
    result = Data.Interface.deleteOne(params)
    logAction(conn, "deleteOne", Json.Utils.toObjectid(params["id"]))
    json conn, result
  end

  @doc """
    ## SOFT Delete using Filter
    Request example /api/v1/softdelete
    {
      "collection": "pizzas",
      "filter":{
        "name": "portuguese",
        "price": 14.9
      }
    }
  """
  def softDeleteMany(conn, params) do
    result = Data.Interface.softDeleteMany(params)
    logAction(conn, "softDeleteMany", params["filter"])
    json conn, result
  end


  @doc """
    ## Soft Delete one record by ID
    Request example /api/v1/softdelete/59fd237c07f8314f0e8133ed
    {
      "collection": "pizzas"
    }
  """
  def softDeleteOne(conn, params) do
    result = Data.Interface.softDeleteOne(params)
    logAction(conn, "softDeleteOne", Json.Utils.toObjectid(params["id"]))
    json conn, result
  end


  # Logs user action

  defp logAction(conn, action, data) do
    user = Enum.at(checkJwtangReturnUser(conn),0)
    Security.Logger.saveLog(action, user["email"], data)
  end

  # Check JWT and returns claims

  defp checkJwtangReturnUser(conn) do
    jwt = get_req_header(conn, "authorization")
    jwt_string = Enum.at(jwt,0)
    {:ok, claims} = Security.Checker.checkAuth(jwt_string)

    getUser = Data.Interface.findByKeyValue("users", "email", claims[:user])
  end


end
