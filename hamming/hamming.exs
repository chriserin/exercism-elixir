defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance(strand1, strand2) do
    reduce_strands(strand1, strand2, 0)
  end

  defp reduce_strands(strand1, strand2, acc) when length(strand1) != length(strand2), do: {:error, "Lists must be the same length"}
  defp reduce_strands([], [], acc), do: {:ok, acc}
  defp reduce_strands([nuc1 | strand1], [ nuc2 | strand2], acc) do
    reduce_strands(strand1, strand2, acc + Enum.min([abs(nuc1 - nuc2), 1]))
  end
end
