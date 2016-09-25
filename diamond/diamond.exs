defmodule Diamond do
  @doc """
  Given a letter, it prints a diamond starting with 'A',
  with the supplied letter at the widest point.
  """
  @spec build_shape(char) :: String.t
  def build_shape(letter) do
    diamond_width = ((letter - ?A) * 2) + 1

    half = for row_letter <- ?A..letter do
      List.duplicate(" ", diamond_width)
      |> List.replace_at(letter - row_letter, to_string([row_letter]))
      |> List.replace_at(diamond_width - (letter - row_letter + 1), to_string([row_letter]))
      |> Enum.join
    end

    Enum.join(half ++ tl(Enum.reverse(half)), "\n") <> "\n"
  end
end
