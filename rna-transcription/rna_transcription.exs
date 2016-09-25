defmodule RNATranscription do

@translation %{
 ?G => ?C,
 ?C => ?G,
 ?T => ?A,
 ?A => ?U
}
  @doc """
  Transcribes a character list representing DNA nucleotides to RNA

  ## Examples

  iex> RNATranscription.to_rna('ACTG')
  'UGAC'
  """
  @spec to_rna([char]) :: [char]
  def to_rna(dna) do
    Enum.map(dna, &get_rna/1)
  end

  def get_rna(char) do
    Map.get(@translation, char)
  end
end
