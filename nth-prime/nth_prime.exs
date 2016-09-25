defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(0), do: raise Error
  def nth(count) do
    Enum.at(all_primes, count - 1)
  end

  defp all_primes do
    determine_primes([2], Enum.to_list(3..1000))
  end

  defp determine_primes(primes, []), do: primes
  defp determine_primes(primes, [p | potentials]) do
    case is_prime?(primes, p) do
      true -> 
        determine_primes(primes ++ [p], potentials)
      false ->
        determine_primes(primes, potentials)
    end
  end

  defp is_prime([prime | primes], p) when rem(p, prime) == 0, do: false
  defp is_prime([prime | primes], p) do
    is_prime(primes, p)
  end
  defp is_prime([], p), do: true
end
