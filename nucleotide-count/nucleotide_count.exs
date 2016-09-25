defmodule NucleotideCount do
  @nucleotides [?A, ?C, ?G, ?T]

  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    unless Enum.any?(@nucleotides, fn(x) -> x == nucleotide end), do: raise ArgumentError

    into_letter_map(strand)
    |> Map.get(nucleotide, [])
    |> Enum.count(fn(x) -> true end)
  end

  @spec histogram([char]) :: map
  def histogram(strand) do
    into_letter_map(strand)
    |> Enum.into(%{})
    |> Enum.filter(fn({letter, list_of_letters}) -> Enum.count(list_of_letters) > 0 end)
    |> Enum.map(fn({letter, list_of_letters}) -> %{letter => Enum.count(list_of_letters)} end)
    |> Enum.reduce(%{?A => 0, ?T => 0, ?C => 0, ?G => 0}, fn(x, acc) -> Enum.into(x, acc) end)
  end

  defp into_letter_map(strand) do
    if String.length(String.replace(List.to_string(strand), ~r/[#{List.to_string(@nucleotides)}]/, "")) > 0, do: raise ArgumentError

    strand
    |> Enum.group_by(fn(c) -> c end)
  end
end
