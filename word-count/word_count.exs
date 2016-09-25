defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t) :: map
  def count(sentence) do
    String.downcase(sentence)
    |> String.split(~r/[^\w-]+|_/iu)
    |> Enum.reject(&(&1 == ""))
    |> Enum.reduce(%{}, fn(word, acc) -> word_count = Map.get(acc, word, 0) + 1; Enum.into(%{word => word_count}, acc) end)
  end
end
