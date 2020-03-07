defmodule GearkitWeb.UserController do
  use GearkitWeb, :controller

  @moduledoc """
    Functions related to Users
  """

  def check_user_exists_by_email(collection, email) do
    user = Data.Interface.findByKeyValue(collection, "email", email)
  end


  @doc """
    ## Check if login data is correct
    Request example: POST to /api/v1/login
    {
      "collection": "users",
      "email": "email@email.com",
      "password": "secret"
    }
  """
  def verify_login(conn, params) do
    user     = params["email"]
    password = params["password"] |> Cipher.encrypt

    getUser = Mongo.find(:mongo, params["collection"], %{"email" => user, "password" => password}, pool: DBConnection.Poolboy) |> Enum.to_list()

    if(Enum.any? getUser) do
      remote_ip = conn.remote_ip |> Tuple.to_list |> Enum.join(".")
      jwt = JsonWebToken.sign(%{user: user, remote_ip: remote_ip}, %{key: Application.get_env(:Gearkit, :spKey)[:value]})
      insertSession(user, jwt, remote_ip)
      json conn |> put_resp_header("authorization", "Bearer #{jwt}"), %{"status"=> 200, "token" => jwt}
    else
      json conn, Responses.Library.errorLogin()
    end

  end

  defp insertSession(email, jwt, remote_ip) do
    params = %{"data" => %{"email"=> email, "jwt"=> jwt, "remote_ip"=> remote_ip}, "collection" => "session"}
    Data.Interface.insertLog(params)
  end

  def logout(conn, params) do
    jwt = get_req_header(conn, "authorization")
    Data.Interface.deleteMany(params)
    json conn, Responses.Library.logoutSuccessful()
  end


  def create_user(conn, params) do

    is_ok = Data.Integrity.assertDataIntegrity(params)

    msg =
      if is_ok do
        userinfo = params["data"];
        user_ok = check_user_exists_by_email(params["collection"], userinfo["email"])

        unless(Enum.any? user_ok) do
          unixFormat = Data.DateUtilities.current_date()

          newUser = %User{
            name: userinfo["name"],
            email: userinfo["email"],
            password: userinfo["password"] |> Cipher.encrypt,
            created_at: unixFormat,
            updated_at: nil,
            active: false,
            birthday: userinfo["birthday"]
          }

          {:ok, pid} = Mongo.insert_one(:mongo, params["collection"], newUser, pool: DBConnection.Poolboy)
          Responses.Library.success();
        else
          user_ok
        end
      else
        Responses.Library.integrityFailed()
      end

    json conn, msg
  end

end
