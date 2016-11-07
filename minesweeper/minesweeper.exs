defmodule Minesweeper do

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t]) :: [String.t]
  def annotate(board) do
    new_board = transform(board)

    new_board
    |> Enum.map(fn({x, y, v}) ->
      {x, y, count_bombs(board, {x, y, v})}
    end)
    |> Enum.reduce(List.duplicate([], length(board)), fn({x, y, v}, acc) ->
      List.replace_at(acc, y, [v | Enum.at(acc, y)])
    end)
    |> Enum.map(&Enum.join/1)
  end

  defp transform(board) do
    for {row, i} <- Enum.with_index(board),
        {col, j} <- Enum.with_index(String.graphemes(row)) do
      {j, i, col}
    end
  end

  defp count_bombs(board, {x, y, "*"}), do: "*"
  defp count_bombs(board, {x, y, v}) do
    neighbor_rows = Enum.with_index(board)
    |> Enum.filter(fn ({_, i})-> abs(i - y) <= 1 end)

    for {n_row, _} <- neighbor_rows do
      n_row
      |> String.graphemes
      |> Enum.with_index
      |> Enum.count(fn({s, i}) ->
        s == "*" && abs(i - x) <= 1
      end)
    end
    |> Enum.sum
    |> case do
      0 -> " "
      a -> a
    end
  end
end
