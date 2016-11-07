defmodule Minesweeper do
  def annotate(board) do
    transformed_board = transform(board)

    transformed_board
    |> Enum.map(fn({x, y, v}) ->
      {x, y, count_bombs(transformed_board, {x, y, v})}
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
    for {bx, by, bv} <- board do
      cond do
        abs(bx - x) <= 1 && abs(by - y) <= 1 && bv == "*" -> "*"
        true -> ""
      end
    end
    |> Enum.join
    |> String.length
    |> case do
      0 -> " "
      a -> a
    end
  end
end
