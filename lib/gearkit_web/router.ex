defmodule GearkitWeb.Router do
  use GearkitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authapi do
    plug :accepts, ["json"]
    plug :authenticate
  end

  scope "/", GearkitWeb do
    pipe_through :browser # Use the default browser stack

    get "/", ShowController, :index
  end

   #Other scopes may use custom stacks.
   scope "/api/v1", GearkitWeb do
     pipe_through :authapi

     get  "/show", ShowController, :show
     post "/show", ShowController, :showFiltered
     post "/showr", ShowController, :showRegexFiltered
     get  "/show_all", ShowController, :showAll
     post  "/count", ShowController, :countCollectionWithFilter

     post "/create", CrudController, :create
     post "/update", CrudController, :updateMany
     post "/update/:id", CrudController, :updateOne
     post "/delete", CrudController, :deleteMany
     post "/delete/:id", CrudController, :deleteOne
     post "/softdelete/:id", CrudController, :softDeleteOne
     post "/softdelete", CrudController, :softDeleteMany

     post "/logout", UserController, :logout

   end

   scope "/api/v1/open", GearkitWeb do
    pipe_through :api

    post "/adduser", UserController, :create_user
    post "/login", UserController, :verify_login

  end

  defp authenticate(conn, _) do

    remote_ip = conn.remote_ip |> Tuple.to_list |> Enum.join(".")
    jwt = get_req_header(conn, "authorization")
    jwt_string = Enum.at(jwt,0)

    # @TODO Too much IFs here and repeated code - Review this Logic

    try do
      if(Enum.any? jwt) do
        data = Data.Interface.findByKeyValue("session", "jwt", jwt_string)
        if(Enum.any? data) do
          case Security.Checker.checkAuth(jwt_string) do
            {:ok, claims} ->
              unless(claims[:remote_ip] == remote_ip) do
                json conn |> put_status(401), Responses.Library.unAuthorized()
                exit(1)
              end
              conn |> put_resp_header("authorization", "Bearer #{jwt}")
            :error ->
              json conn |> put_status(401), Responses.Library.unAuthorized()
              exit(1)
          end
        else
          json conn |> put_status(401), Responses.Library.unAuthorized()
          exit(1)
        end
      else
        json conn |> put_status(401), Responses.Library.unAuthorized()
        exit(1)
      end
    rescue
      RuntimeError -> Responses.Library.unAuthorized()
      json conn |> put_status(401), Responses.Library.logoutSuccessful()
      exit(1)
    end
  end

end
