defmodule Change do
  @spec generate(integer, list) :: {:ok, map} | :error
  def generate(amount, values) do
    solutions = cycle_permutations(Enum.reverse(Enum.sort(values)), amount, [])
    top_solution = Enum.find(Enum.reverse(solutions), fn({coins, amount_left}) -> amount_left == 0 end)

    cond do
      is_nil(top_solution) -> :error
      true -> 
        {:ok, translate(values, top_solution)}
    end
  end

  defp translate(values, {coins, _}) do
    Enum.reduce(values, %{}, fn(v, acc) ->
      Map.put(acc, v, Enum.count(coins, &(&1 == v)))
    end)
  end

  defp cycle_permutations([], amount, acc), do: acc
  defp cycle_permutations(values, amount, acc) do
    cycle_permutations(tl(values), amount, [reduce(values, amount, []) | acc])
  end

  def reduce([], amount, acc), do: {acc, amount}
  def reduce([v | rest] = values, amount, acc) do
    result = amount - v
    cond do
      result > 0 -> reduce(values, result, [v | acc])
      result < 0 -> reduce(rest, amount, acc)
      result == 0 -> {[v | acc], 0}
    end
  end
end
