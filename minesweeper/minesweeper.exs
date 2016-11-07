defmodule Minesweeper do

  @doc """
  Annotate empty spots next to mines with the number of mines next to them.
  """
  @spec annotate([String.t]) :: [String.t]
  def annotate(board) do
    new_board = replace_space(board)
    new_board
    |> Enum.map(fn(row) -> String.replace(row, "X", " ") end)
  end

  defp replace_space(board) do
    space_coords = List.first(find_spaces(board))

    cond do
      space_coords == nil ->
        board
      space_coords ->
        horiz_bombs = count_bombs(board, space_coords)
        replace_space_w_count(board, horiz_bombs + 0, space_coords)
        |> replace_space
    end
  end

  defp find_spaces(board) do
    for {row, i} <- Enum.with_index(board),
        {col, j} <- Enum.with_index(String.graphemes(row)) do
      {j, i, col}
    end
    |> Enum.filter(fn({_, _, col})-> col == " " end)
    |> Enum.map(fn({x, y, col})-> {x, y} end)
  end

  defp count_bombs(board, {x, y}) do
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
  end

  defp replace_space_w_count(board, count, {x, y}) do
    replacement_char = if count == 0 do
      "X"
    else
      count
    end

    board
    |> Enum.with_index
    |> Enum.map(fn({row, i}) ->
        cond do
          y == i ->
            List.replace_at(String.graphemes(row), x, replacement_char) |> Enum.join
          true ->
            row
        end
    end)
  end
end
