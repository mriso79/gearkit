defmodule GearkitWeb.ShowController do
  use GearkitWeb, :controller

  def index(conn, params) do
    render conn, "index.html"
  end

  @doc """
    ## Show a pageable list of items
    Request example: GET to /api/v1/show?collection=pizzas&limit=20&skip=0
  """
  def show(conn, params) do
    cursor = Data.Interface.simple_find(params)
    json conn, cursor
  end

  @doc """
    ## Show a pageable list of items, with softdeleted
    Request example: GET to /api/v1/show?collection=pizzas&limit=20&skip=0
  """
  def showAll(conn, params) do
    cursor = Data.Interface.findWithDeleted(params)
    json conn, cursor
  end

  @doc """
    ## Show a pageable list of filtered items
    Request example: POST to /api/v1/show
    {
      "collection": "pizzas",
      "filter":{
        "name": "portuguese",
        "price": 12.51
      }
    }
  """
  def showFiltered(conn, params) do
    cursor = Data.Interface.findFiltered(params)
    json conn, cursor
  end



    @doc """
     ## Show a pageable list of filtered items
     searching by Regex a value
     Request example: POST to /api/v1/showr
     {
       "collection": "pizzas",
       "filter":{
         "field": "name",
         "value": "portuguese"
       }
     }
   """
  def showRegexFiltered(conn, params) do
    cursor = Data.Interface.findRegexFiltered(params)
    json conn, cursor
  end

  @doc """
    ## Count list of filtered items. Filter should be at least empty.
    Request example: POST to /api/v1/count
    {
      "collection": "pizzas",
      "filter":{
        "name": "portuguese",
        "price": 12.51
      }
    }
  """
  def countCollectionWithFilter(conn, params) do
    cursor = Data.Interface.count(params)
    json conn, cursor
  end

end
