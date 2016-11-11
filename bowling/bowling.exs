defmodule Bowling do
  def start do
    [{}]
  end

  def roll([current | rest] = game, roll) do
    case tuple_size(current) do
      0 ->
        [{roll} | rest]
      1 ->
        {first_roll} = current
        [{}, {first_roll, roll} | rest]
    end
  end

  def score(game) do
    game
    |> Enum.map(fn ({a, b})-> a + b end)
    |> Enum.sum
  end
end
