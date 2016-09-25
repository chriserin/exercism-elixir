defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t, [String.t]) :: [String.t]
  def match(base, candidates) do
    lowered_base = String.downcase(base)

    candidates
    |> Enum.reject(&(String.downcase(&1) == lowered_base))
    |> Enum.filter(&(sort_word(&1) == sort_word(base)))
  end

  def sort_word(word) do
    word
      |> String.downcase
      |> String.codepoints
      |> Enum.sort
  end
end
