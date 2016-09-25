defmodule Roman do
  @possible_roman_numbers [
    ["", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"],
    ["", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"],
    ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"],
    ["", "M", "MM", "MMM"]
  ]

  2184

  4812

  @doc """
  Convert the number to a roman number.
  """
  @spec numerals(pos_integer) :: String.t
  def numerals(number) do
    Integer.to_string(number)
    |> String.codepoints
    |> Enum.map(&(Integer.parse(&1)))
    |> Enum.map(fn({v, _}) -> v end)
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn({k, i}) ->
      Enum.at(@possible_roman_numbers, i)
      |> Enum.at(k)
    end)
    |> Enum.reverse
    |> Enum.join
  end
end
