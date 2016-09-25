defmodule Scrabble do

  @letters %{
    "A, E, I, O, U, L, N, R, S, T" => 1,
    "D, G" => 2,
    "B, C, M, P" => 3,
    "F, H, V, W, Y" => 4,
    "K" => 5,
    "J, X" => 8,
    "Q, Z" => 10,
  }

 @doc """
 Calculate the scrabble score for the word.
 """
 @spec score(String.t) :: non_neg_integer
 def score(word) do
  String.trim(word)
  |> String.codepoints
  |> Enum.reduce(0, &(points(&1) + &2))
 end

 def points(letter) do
   {_, points} = Enum.find(@letters, fn({k, v}) -> String.contains?(k, String.upcase(letter)) end)
   points
 end
end
