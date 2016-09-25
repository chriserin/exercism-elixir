defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(num) do
    reduce_rows(num - 1, [[1]])
    |> Enum.reverse
  end

  defp reduce_rows(0, acc), do: acc
  defp reduce_rows(row, [prev_row | _] = acc) do
    new_row = reduce_row(0, prev_row, [])
    reduce_rows(row - 1, [new_row | acc])
  end

  defp reduce_row(prev_elem, [], acc), do: [ 1 | acc]
  defp reduce_row(prev_elem, [current_elem | rest], acc) do
    reduce_row(current_elem, rest, [prev_elem + current_elem | acc])
  end
end
