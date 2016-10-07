defmodule Series do

  @doc """
  Finds the largest product of a given number of consecutive numbers in a given string of numbers.
  """
  @spec largest_product(String.t, non_neg_integer) :: non_neg_integer

  def product([]), do: 0

  def product(numbers) when is_list(numbers) do
    Enum.reduce(numbers, 1, fn(x, acc) -> x * acc end)
  end

  def largest_product(number_string, size) do
    cond do
      String.length(number_string) < size -> raise ArgumentError
      size < 0 -> raise ArgumentError
      size == 0 -> 1
      number_string == "" -> 0
      true ->
        find_largest_product(number_string, size)
    end
  end

  defp find_largest_product(number_string, size) do

    number_string
    |> String.to_integer
    |> Integer.digits
    |> Enum.chunk(size, 1)
    |> map_products
    |> Enum.max
  end

  defp map_products([]), do: [0]
  defp map_products(lists) do
    Enum.map(lists, &product/1)
  end
end
