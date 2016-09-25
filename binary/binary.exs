defmodule Binary do

  def to_decimal(string) do
    string
    |> String.codepoints
    |> Enum.reverse
    |> to_decimal(0, 0)
  end

  def to_decimal([], _, acc), do: acc
  def to_decimal(["0" | t], counter, acc), do: to_decimal(t, counter + 1, acc)
  def to_decimal(["1" | t], counter, acc) do
    to_decimal(t, counter + 1, acc + :math.pow(2, counter))
  end

  def to_decimal([h | _], _, _), do: 0
end
