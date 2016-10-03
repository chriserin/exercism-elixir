defmodule PrimeFactors do
  @doc """
  Compute the prime factors for 'number'.

  The prime factors are prime numbers that when multiplied give the desired
  number.

  The prime factors of 'number' will be ordered lowest to highest.
  """
  @spec factors_for(pos_integer) :: [pos_integer]
  def factors_for(number) do
    do_factors_for(number, [])
  end

  defp do_factors_for(1, acc), do: Enum.reverse(acc)
  defp do_factors_for(number, acc) do
    backwards_range = &(Range.new(&2, &1))

    factor =
      :math.sqrt(number)
      |> Float.ceil
      |> round
      |> backwards_range.(List.first(acc) || 2)
      |> Enum.find(fn(x) -> rem(number, x) == 0 end)

    cond do
      factor == nil -> 
        [number | acc]
      true ->
        [factor | do_factors_for(div(number, factor), acc)]
    end
  end
end
