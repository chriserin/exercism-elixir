defmodule Atbash do
  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t) :: String.t
  def encode(plaintext) do
    plaintext
    |> String.replace(~r/\W/, "")
    |> String.downcase
    |> to_charlist
    |> Enum.map(
    fn
      (x) when x >= 97 and x <= 123 ->
        13 - (x + 1 - 97) + 13 + 97
      (x) ->
        x
    end)
    |> Enum.with_index
    |> Enum.map(
    fn
      ({x, i}) when rem(i + 1, 5) == 0 -> [x, ' ']
      ({x, i})                         -> x
    end)
    |> List.to_string
    |> String.trim
  end
end
