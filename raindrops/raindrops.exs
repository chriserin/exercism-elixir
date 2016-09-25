defmodule Raindrops do
  @vowels ["i", "a", "o"]

  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t
  def convert(number) do
    Enum.with_index([3, 5, 7])
    |> Enum.filter(fn({n, i}) -> rem(number, n) == 0 end)
    |> Enum.reduce(nil, fn({n, i}, acc) -> Enum.join([acc, "Pl", Enum.at(@vowels, i), "ng"]) end)
    ||
    to_string(number)
  end
end
