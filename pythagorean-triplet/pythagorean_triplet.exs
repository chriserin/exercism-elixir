defmodule Triplet do

  @doc """
  Calculates sum of a given triplet of integers.
  """
  @spec sum([non_neg_integer]) :: non_neg_integer
  def sum(triplet) do
    Enum.reduce(triplet, 0, &(&1 + &2))
  end

  @doc """
  Calculates product of a given triplet of integers.
  """
  @spec product([non_neg_integer]) :: non_neg_integer
  def product(triplet) do
    Enum.reduce(triplet, 1, &(&1 * &2))
  end

  @doc """
  Determines if a given triplet is pythagorean. That is, do the squares of a and b add up to the square of c?
  """
  @spec pythagorean?([non_neg_integer]) :: boolean
  def pythagorean?([a, b, c]) do
    :math.pow(a, 2) + :math.pow(b, 2) == :math.pow(c, 2)
  end

  @doc """
  Generates a list of pythagorean triplets from a given min (or 1 if no min) to a given max.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max) do
    squares = min..max
              |> Enum.map(&(&1 * &1))

    squares
    |> Enum.reduce([], fn(x, acc) ->
      Enum.into(
        List.duplicate(x, length(squares))
        |> Enum.zip(squares), acc)
    end)
    |> Enum.filter(fn({x, y}) -> t = x - y; Enum.find(squares, fn(s) -> t == s end) end)
    |> Enum.map(fn({x, y}) -> Enum.sort([trunc(:math.sqrt(x)), trunc(:math.sqrt(x - y)), trunc(:math.sqrt(y))]) end)
    |> Enum.uniq
  end

  @doc """
  Generates a list of pythagorean triplets from a given min to a given max, whose values add up to a given sum.
  """
  @spec generate(non_neg_integer, non_neg_integer, non_neg_integer) :: [list(non_neg_integer)]
  def generate(min, max, sum) do
    generate(min, max)
    |> Enum.filter(fn(t) -> sum(t) == 180 end)
    |> Enum.sort
  end
end
