defmodule Acronym do
  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.split
    |> Enum.map(fn(<< a::binary-1, rest::binary >>) -> String.upcase(a) <> rest end)
    |> Enum.join(" ")
    |> to_charlist
    |> Enum.filter(&(&1 >= 65 and &1 <=90))
    |> to_string
  end
end
