defmodule Connect do
  def result_for(board) do
    transformed_board = transform(board)

    white_starters = Enum.filter(transformed_board, fn({x, y, v}) -> y == 0 && v == "O" end)
    white_success = fn({x, y, "O"})-> y == length(board) - 1 end
    black_starters = Enum.filter(transformed_board, fn({x, y, v}) -> x == 0 && v == "X" end)
    black_success = fn({x, y, "X"})-> x == String.length(hd(board)) - 1 end

    cond do
      follow(white_starters, transformed_board, white_success, []) -> :white
      follow(black_starters, transformed_board, black_success, []) -> :black
      true -> :none
    end
  end

  defp follow([], board, success_fn, path), do: false
  defp follow(possibles, board, success_fn, path) do
    cond do
      Enum.any?(possibles, success_fn) ->
        true
      true ->
        follow_possibles(possibles, board, success_fn, path)
    end
  end

  defp follow_possibles(possibles, board, success_fn, path) do
    Enum.any?(possibles, fn(poss_coords) ->
      next_possibles = Enum.filter(board, fn (board_coords) ->
        Enum.find_value(next_coords(poss_coords), fn(coords) ->
          coords == board_coords && !Enum.find_value(path, fn(path_coords) -> path_coords == coords end)
        end)
      end)

      follow(next_possibles, board, success_fn, [poss_coords | path])
    end)
  end

  defp next_coords({x, y, v} = coords) do
    [{x + 1, y, v}, {x, y + 1, v}, {x - 1, y, v}, {x, y - 1, v},
    {x + 1, y + 1, v}, {x - 1, y + 1, v}, {x + 1, y - 1, v}, {x - 1, y - 1, v}]
  end

  defp transform(board) do
    for {row, i} <- Enum.with_index(board),
        {col, j} <- Enum.with_index(String.graphemes(row)) do
      {j, i, col}
    end
  end
end
