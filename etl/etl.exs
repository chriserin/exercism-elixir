defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"], "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(map) :: map
  def transform(input) do
    Enum.reduce(input, %{}, fn({key, values}, acc) ->
      Enum.into(reverse_map_item(key, values), acc)
    end)
  end

  def reverse_map_item(key, values) do
    Enum.reduce(values, %{}, fn(new_key, map) -> 
      Map.put(map, String.downcase(new_key), key)
    end)
  end
end
