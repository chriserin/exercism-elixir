defmodule Sieve do

  @doc """
  Generates a list of primes up to a given limit.
  """
  @spec primes_to(non_neg_integer) :: [non_neg_integer]
  def primes_to(limit) do
    sieve(Enum.into(2..limit, []), 2)
  end

  defp sieve(acc, nil), do: acc
  defp sieve(acc, filter_number) do
    sieved = Enum.filter(acc, fn(x) ->
      rem(x, filter_number) != 0 || x == filter_number
    end)

    sieve(sieved, Enum.find(sieved, &(&1 > filter_number)))
  end
end
