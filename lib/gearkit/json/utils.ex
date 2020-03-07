defmodule Json.Utils do

  def decoder (json_string) do
    JSON.decode(json_string)
  end

  def toObjectid(id) do
    {_, idbin} = Base.decode16(id, case: :mixed)
    %BSON.ObjectId{value: idbin}
  end

end
