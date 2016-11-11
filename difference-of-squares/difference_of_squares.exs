defmodule Squares do

  def sum_of_squares(number) do
    Enum.sum(Enum.map(0..number, fn(n) -> n * n end))
  end

  def square_of_sums(number) do
    Enum.sum(0..number)
     |> :math.pow(2)
  end

  def difference(number) do
    square_of_sums(number) - sum_of_squares(number)
  end

end
