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
    |> to_char_list
    |> Enum.map(
    fn
      (x) when x >= 97 and x <= 123 ->
        13 - (x + 1 - 97) + 13 + 97
      (x) ->
        x
    end)
    |> Enum.chunk(5, 5, [])
    |> Enum.map(&List.to_string/1)
    |> Enum.join " "
  end
end
