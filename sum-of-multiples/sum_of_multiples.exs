defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    0..(limit - 1)
    |> Enum.filter(&(factorable(&1, factors)))
    |> Enum.sum
  end

  def factorable(number, factors) do
    Enum.any? factors, &(rem(number, &1)) == 0
  end
end
