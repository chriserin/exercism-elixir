defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: { :ok, kind } | { :error, String.t }
  def kind(a, b, c) do
    kind(Enum.sort([a, b, c]))
  end

  def kind([a, b, c]) when a <= 0 or b <= 0 or c <= 0, do: { :error, "all side lengths must be positive" }
  def kind([a, b, c]) when a + b <= c , do: { :error, "side lengths violate triangle inequality" }

  def kind([a, a, a]), do: {:ok, :equilateral}
  def kind([a, a, b]), do: {:ok, :isosceles}
  def kind([a, b, b]), do: {:ok, :isosceles}
  def kind([a, b, c]), do: {:ok, :scalene}
end
