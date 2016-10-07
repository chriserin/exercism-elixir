defmodule Series do

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer

  def largest_product(number_string, size) do
    cond do
      String.length(number_string) < size -> raise ArgumentError
      size < 0                            -> raise ArgumentError
      size == 0                           -> 1
      number_string == ""                 -> 0
      true -> find_largest_product(number_string, size)
    end
  end

  defp find_largest_product(number_string, size) do
    number_string
    |> String.to_char_list
    |> Enum.map(&(&1 - 48))
    |> Enum.chunk(size, 1)
    |> Enum.map(&product/1)
    |> Enum.max
  end

  defp product(list), do: Enum.reduce(list, 1, &*/2)
end
