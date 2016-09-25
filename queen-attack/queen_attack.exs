defmodule Queens do
  @type t :: %Queens{ black: {integer, integer}, white: {integer, integer} }
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  def new() do
    %Queens{ black: {7, 3}, white: {0, 3}}
  end

  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new({x, y}, {x, y}), do: raise ArgumentError, message: 'Queens cannot occupy the same space'
  def new(white, black) do
    %Queens{ black: black, white: white }
  end

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    0..7
    |> Enum.map(fn (row_num)-> row_to_string(queens, row_num) end)
    |> Enum.join("\n")
  end

  defp row_to_string(queens, row_num) do
    0..7
    |> Enum.map(fn (column_num)->
      cond do
        queens.black == {row_num, column_num} -> "B"
        queens.white == {row_num, column_num} -> "W"
        true -> "_"
      end
    end)
    |> Enum.join(" ")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(%Queens{black: {black_x, black_y}, white: {white_x, white_y}}) do
    black_x == white_x
    ||
    black_y == white_y
    ||
    abs(black_x - white_x) == abs(black_y - white_y)
  end
end
