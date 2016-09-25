defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t) :: boolean
  def isogram?(sentence) do
    massaged_sentence = String.replace(sentence, ~r/\W/u, "")
    |> String.graphemes

    length(massaged_sentence) == massaged_sentence
    |> Enum.uniq
    |> length
  end
end
