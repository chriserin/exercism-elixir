defmodule CryptoSquare do
  @spec encode(String.t) :: String.t
  def encode(str) do
    with compressed_str <- str |> String.replace(~r/[^\w\d]/, ""),
         size           <- square_height(String.length(compressed_str)),
         lists          <- List.duplicate([], size),
    do: compressed_str
      |> String.downcase
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(lists, fn({c, i}, acc) ->
        y = rem(i, size)
        List.replace_at(acc, y, [ c | Enum.at(acc, y)])
      end)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.join(" ")
  end

  defp square_height(size) do
    trunc(Float.ceil(:math.sqrt(size)))
  end
end
