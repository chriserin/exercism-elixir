defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(1), do: 1
  def square(number) do
    Enum.reduce(1..(number - 1), 1, fn(_, acc) -> acc * 2 end)
  end

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total(), do: total(2, 1, 1)
  def total(65, acc, prev_result), do: acc
  def total(count, acc, prev_result) do
    result = prev_result * 2
    total(count + 1, acc + result, result)
  end
end
