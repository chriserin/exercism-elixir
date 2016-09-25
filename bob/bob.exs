defmodule Bob do
  def hey(input) do
    cond do
      "" == String.trim(input) -> "Fine. Be that way!"
      is_question(input) -> "Sure."
      is_all_caps(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp is_all_caps(input) do
    String.upcase(input) == input && String.downcase(input) != String.upcase(input)
  end

  defp is_question(input) do
    input
    |> to_charlist
    |> List.last
    |> eq(??)
  end

  defp eq(lhs, rhs) do
    lhs == rhs
  end
end
