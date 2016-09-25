defmodule Luhn do
  @doc """
  Calculates the total checksum of a number
  """
  @spec checksum(String.t()) :: integer
  def checksum(number) do
    number
    |> String.codepoints
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(&double/1)
    |> Enum.sum
  end

  defp double({number, i}) when rem(i, 2) == 0, do: String.to_integer(number)
  defp double({number, i}) do
    num = String.to_integer(number) * 2

    cond do
      num > 9 -> num - 9
      true -> num
    end
  end

  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    rem(checksum(number), 10) == 0
  end

  @spec create(String.t()) :: String.t()
  def create(number) do
    correcting_num = 0..9
    |> Enum.map(fn(n) -> number <> Integer.to_string(n) end)
    |> Enum.filter(fn(n) -> valid?(n) end)
    |> hd
  end
end
