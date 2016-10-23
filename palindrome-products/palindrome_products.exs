defmodule Palindromes do

  @doc """
  Generates all palindrome products from an optionally given min factor (or 1) to a given max factor.
  """
  @spec generate(non_neg_integer, non_neg_integer) :: map
  def generate(max_factor, min_factor \\ 1) do
    palindromes = for i <- min_factor..max_factor, j <- min_factor..max_factor do
      product = i * j
      str_product = Integer.to_string(product)
      cond do
        str_product == String.reverse(str_product) -> 
          {product, Enum.sort([i,j])}
        true ->
          nil
      end
    end

    palindromes
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.reduce(%{}, fn({x, y}, acc) -> Map.put(acc, x, Enum.uniq([y | Map.get(acc, x, [])])) end)
  end
end
