defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "HORSE" => "1H1O1R1S1E"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "1H1O1R1S1E" => "HORSE"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    reduce_string(string, [])
    |> Enum.join
  end

  defp reduce_string("", points), do: points
  defp reduce_string(string, points) do
    letter = String.last(string)
    new_string = String.trim_trailing(string, letter)

    reduce_string(
      new_string,
      [String.length(string) - String.length(new_string), letter | points]
    )
  end

  @spec decode(String.t) :: String.t
  def decode(string) do
    string
    |> String.split(~r/\d+/, trim: true, include_captures: true)
    |> decode_reduce("")
  end

  defp decode_reduce([], result), do: result
  defp decode_reduce([digits, letter | rest], result) do
    count = String.to_integer(digits) + String.length(result)
    decode_reduce(
      rest,
      String.pad_trailing(result, count, letter)
    )
  end
end
