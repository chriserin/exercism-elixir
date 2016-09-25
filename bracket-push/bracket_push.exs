defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t) :: boolean
  def check_brackets(str) do
    check_bracket(str, [])
  end

  defp check_bracket("", []), do: true
  defp check_bracket("{" <> str, waiting_for), do: check_bracket(str, ["}" | waiting_for])
  defp check_bracket("(" <> str, waiting_for), do: check_bracket(str, [")" | waiting_for])
  defp check_bracket("[" <> str, waiting_for), do: check_bracket(str, ["]" | waiting_for])
  defp check_bracket(<<close :: binary-1, str :: binary>>, [close | waiting_for]), do: check_bracket(str, waiting_for)
  defp check_bracket(<<char :: binary-1, _ :: binary>>, _) when char in ["}",")","]"], do: false
  defp check_bracket(<<_ :: binary-1, str :: binary>>, waiting_for), do: check_bracket(str, waiting_for)
  defp check_bracket("", _), do: false
end
