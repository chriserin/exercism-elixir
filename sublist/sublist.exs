defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
      a === b ->
        :equal
      is_superlist(a, b) ->
        :superlist
      is_superlist(b, a) ->
        :sublist
      true ->
        :unequal
    end
  end

  defp is_superlist(a, b) do
    cond do
      length(a) <= length(b) ->
        false
      is_superlist(a, b, 0, false) -> 
        true
      true -> 
        false
    end
  end

  defp is_superlist(a, b, index, false) do
    slice = Enum.slice(a, index..(index + length(b) - 1))

    cond do
      length(b) == 0 ->
        true
      Enum.max(b) > Enum.max(a) ->
        false
      length(a) < index ->
        false
      length(slice) > length(a) ->
        false
      hd(b) == Enum.at(a, index) && slice === b ->
        true
      true ->
        is_superlist(a, b, index + 1, false)
    end
  end
end
