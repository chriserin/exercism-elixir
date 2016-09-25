defmodule Hexadecimal do
  @doc """
    Accept a string representing a hexadecimal value and returns the
    corresponding decimal value.
    It returns the integer 0 if the hexadecimal is invalid.
    Otherwise returns an integer representing the decimal value.

    ## Examples

      iex> Hexadecimal.to_decimal("invalid")
      0

      iex> Hexadecimal.to_decimal("af")
      175

  """

  @spec to_decimal(binary) :: integer
  def to_decimal(hex) do
    cond do
      hex =~ ~r/[^a-f0-9]+/i -> 0
      true -> to_dec(hex)
    end
  end

  defp to_dec(hex) do
    hex
    |> String.downcase
    |> to_charlist
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn ({h, i}) -> hex_2_dec(h) * :math.pow(16, i) end)
    |> Enum.sum
  end

  defp hex_2_dec(hex) do
    cond do
      hex >= 97 -> hex - 87
      hex <= 58 -> hex - 48
    end
  end
end
