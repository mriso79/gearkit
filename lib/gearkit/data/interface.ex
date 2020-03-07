defmodule Data.Interface do
  @moduledoc """
  Data.Interface is a layer that communicates directly with the Mongo DB
  """

  def findByKeyValue(collection, key, value) do
    if(collection) do
      Mongo.find(:mongo, collection, %{key => value}, pool: DBConnection.Poolboy) |> Enum.to_list()
    else
      Responses.Library.missingCollectionParameter()
    end
  end

  def simple_find(params) do
    search =
      if params["searchby"] do
        searchfield = params["searchby"]
        %{searchfield => params["value"], "deleted_at" => nil}
      else
        %{"deleted_at" => nil}
      end

    if params["limit"] do
      if params["skip"] do
        {lim, _} = Integer.parse(params["limit"])
        {skp, _} = Integer.parse(params["skip"])
        Mongo.find(:mongo, params["collection"], search, limit: lim, skip: skp, pool: DBConnection.Poolboy) |> Enum.to_list()
      else
        Responses.Library.missingSkipParameter()
      end
    else
      Responses.Library.missingLimitParameter()
    end

  end

  def findFiltered(params) do
    is_ok = Data.Integrity.assertFilterIntegrity(params)

    msg =
      if is_ok do
        if params["limit"] do
          if params["skip"] do
            {lim, _} = Integer.parse(params["limit"])
            {skp, _} = Integer.parse(params["skip"])
            Mongo.find(:mongo, params["collection"], params["filter"], limit: lim, skip: skp, pool: DBConnection.Poolboy) |> Enum.to_list()
          else
            Responses.Library.missingSkipParameter()
          end
        else
          Responses.Library.missingLimitParameter()
        end
      else
        Responses.Library.filterIntegrityFailed()
      end

  end

  def findRegexFiltered(params) do
    is_ok = Data.Integrity.assertFilterIntegrity(params)

    msg =
      if is_ok do
        if params["limit"] do
          if params["skip"] do
            {lim, _} = Integer.parse(params["limit"])
            {skp, _} = Integer.parse(params["skip"])
            Mongo.find(:mongo, params["collection"], %{params["filter"]["field"] => %BSON.Regex{pattern: params["filter"]["value"], options: "i" }}, limit: lim, skip: skp, pool: DBConnection.Poolboy) |> Enum.to_list()
          else
            Responses.Library.missingSkipParameter()
          end
        else
          Responses.Library.missingLimitParameter()
        end
      else
        Responses.Library.filterIntegrityFailed()
      end

  end

  def findWithDeleted(params) do
    search =
      if params["searchby"] do
        searchfield = params["searchby"]
        %{searchfield => params["value"]}
      else
        %{}
      end

    if params["limit"] do
      if params["skip"] do
        {lim, _} = Integer.parse(params["limit"])
        {skp, _} = Integer.parse(params["skip"])
        Mongo.find(:mongo, params["collection"], search, limit: lim, skip: skp, pool: DBConnection.Poolboy) |> Enum.to_list()
      else
        Responses.Library.missingSkipParameter()
      end
    else
      Responses.Library.missingLimitParameter()
    end

  end

  def insert(params, user) do
    is_ok = Data.Integrity.assertDataIntegrity(params)
    msg =
      if is_ok do
        unixFormat = Data.DateUtilities.current_date()
        mongoDoc = Map.put(params["data"], "created_at", unixFormat)
        mongoDoc = Map.put(mongoDoc, "user", user["_id"])
        {:ok, pid} = Mongo.insert_one(:mongo, params["collection"], mongoDoc, pool: DBConnection.Poolboy)
        Responses.Library.success();
      else
        Responses.Library.integrityFailed()
      end
  end

  def insertLog(params) do
    is_ok = Data.Integrity.assertDataIntegrity(params)
    msg =
      if is_ok do
        unixFormat = Data.DateUtilities.current_date()
        mongoDoc = Map.put(params["data"], "created_at", unixFormat)
        {:ok, pid} = Mongo.insert_one(:mongo, params["collection"], mongoDoc, pool: DBConnection.Poolboy)
        Responses.Library.success();
      else
        Responses.Library.integrityFailed()
      end
  end


  def updateOne(params) do
    id = Json.Utils.toObjectid(params["id"])

    is_ok = Data.Integrity.assertDataIntegrity(params)
    msg =
      if is_ok do
        # Adding Update time
        unixFormat = Data.DateUtilities.current_date()
        mongoDoc = Map.put(params["data"], "updated_at", unixFormat)

        {:ok, result} = Mongo.find_one_and_update(:mongo, params["collection"],
          %{"_id" => id},
          %{"$set" => mongoDoc },
          [return_document: :after, pool: DBConnection.Poolboy])

        result
      else
        Responses.Library.integrityFailed()
      end
  end

  def updateMany(params) do
    is_ok = Data.Integrity.assertFilterIntegrity(params)

    msg =
      if is_ok do
        # Adding Update time
        unixFormat = Data.DateUtilities.current_date()
        mongoDoc = Map.put(params["data"], "updated_at", unixFormat)

        {:ok, result} = Mongo.update_many(:mongo, params["collection"],
          params["filter"],
          %{"$set" => mongoDoc },
          [return_document: :after, pool: DBConnection.Poolboy])

        result
      else
        Responses.Library.filterIntegrityFailed()
      end
  end

  def deleteMany(params) do
    is_ok = Data.Integrity.assertFilterIntegrity(params)

    msg =
      if is_ok do
        {:ok, result} = Mongo.delete_many(:mongo, params["collection"],
          params["filter"],
          [return_document: :after, pool: DBConnection.Poolboy])

        result
      else
        Responses.Library.filterIntegrityFailed()
      end
  end

  def deleteOne(params) do
    id = Json.Utils.toObjectid(params["id"])

    is_ok = Data.Integrity.assertCollectionParameter(params)
    msg =
      if is_ok do
        {:ok, result} = Mongo.delete_one(:mongo, params["collection"],
          %{"_id" => id},
          [return_document: :after, pool: DBConnection.Poolboy])

        result
      else
        Responses.Library.missingCollectionParameter()
      end
  end

  def softDeleteMany(params) do
    is_ok = Data.Integrity.assertFilterIntegrity(params)

    msg =
      if is_ok do
        # Adding Soft Delete time
        unixFormat = Data.DateUtilities.current_date()
        mongoDoc = Map.put(params["data"], "deleted_at", unixFormat)

        {:ok, result} = Mongo.update_many(:mongo, params["collection"],
          params["filter"],
          %{"$set" => mongoDoc },
          [return_document: :after, pool: DBConnection.Poolboy])

        result
      else
        Responses.Library.filterIntegrityFailed()
      end
  end


  def softDeleteOne(params) do
    id = Json.Utils.toObjectid(params["id"])

    is_ok = Data.Integrity.assertCollectionParameter(params)
    msg =
      if is_ok do
        # Adding Soft Delete time
        unixFormat = Data.DateUtilities.current_date()
        mongoDoc = %{"deleted_at" => unixFormat}

        {:ok, result} = Mongo.find_one_and_update(:mongo, params["collection"],
          %{"_id" => id},
          %{"$set" => mongoDoc },
          [return_document: :after, pool: DBConnection.Poolboy])

        result
      else
        Responses.Library.missingCollectionParameter()
      end
  end

  def count(params) do
    is_ok = Data.Integrity.assertFilterIntegrity(params)

    msg =
      if is_ok do
        {:ok, result} = Mongo.count(:mongo, params["collection"], params["filter"], pool: DBConnection.Poolboy)
        %{"count" => result}
      else
        Responses.Library.filterIntegrityFailed()
      end
  end

end
