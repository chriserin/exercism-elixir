defmodule Matrix do
  @doc """
  Parses a string representation of a matrix
  to a list of rows
  """
  @spec rows(String.t()) :: [[integer]]
  def rows(str) do
    String.split(str, "\n")
    |> Enum.map(&(Enum.map(String.split(&1, " "), fn (s)-> String.to_integer(s) end)))
  end

  @doc """
  Parses a string representation of a matrix
  to a list of columns
  """
  @spec columns(String.t()) :: [[integer]]
  def columns(str) do
    rows = rows(str)
    reduce_pivot(rows, List.duplicate([], length(rows)))
  end

  defp reduce_pivot([], columns), do: Enum.map(columns, &Enum.reverse/1)
  defp reduce_pivot([row | rows], columns) do
    columns = row
    |> Enum.with_index
    |> Enum.reduce(columns, fn({row, i}, columns) -> List.update_at(columns, i, &([row | &1])) end)

    reduce_pivot(rows, columns)
  end

  @doc """
  Calculates all the saddle points from a string
  representation of a matrix
  """
  @spec saddle_points(String.t()) :: [{integer, integer}]
  def saddle_points(str) do
    r_set = saddle_point_coords(rows(str), &Enum.max/1)
            |> MapSet.new

    c_set = saddle_point_coords(columns(str), &Enum.min/1)
            |> Enum.map(fn({y, x}) -> {x, y} end)
            |> MapSet.new

    MapSet.intersection(r_set, c_set)
    |> MapSet.to_list
  end

  defp saddle_point_coords(arr, fun) do
    arr
    |> Enum.with_index
    |> Enum.map(fn({arr, i}) ->
      Enum.map(index_of(arr, fun), fn (j) -> {i, j} end)
    end)
    |> List.flatten
  end

  defp index_of(arr, fun) do
    arr
    |> Enum.with_index
    |> Enum.filter(fn({e, i})-> e == fun.(arr) end)
    |> Enum.map(fn({_, i}) -> i end)
  end
end
