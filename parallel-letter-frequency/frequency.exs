defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency(texts, workers \\ 1) do
    texts
    |> Enum.join
    |> list_round_robbin(workers)
    |> Enum.map(&Task.async(fn -> count_letters_in_text(&1) end))
    |> Enum.map(&Task.await(&1))
    |> Enum.reduce(%{}, fn(m, acc) ->
      Map.merge(m, acc, fn(_k, v1, v2) ->
        v1 + v2
      end)
    end)
  end

  defp list_round_robbin(text, list_count) do
    lists = Enum.map(1..list_count, fn(_) -> [] end)

    text
    |> to_charlist
    |> Enum.with_index
    |> Enum.reduce(lists, fn({x, i}, acc) ->
      index = rem(i, list_count)
      List.replace_at(acc, index, [x | Enum.at(acc, index)])
    end)
  end

  defp count_letters_in_text(text) do
    text
    |> List.to_string
    |> String.downcase
    |> String.replace(~r/[\W\d]/u, "")
    |> to_charlist
    |> Enum.sort
    |> Enum.chunk_by(&(&1))
    |> Enum.reduce(%{}, fn(l, acc) -> Map.put(acc, List.to_string([hd(l)]), length(l)) end)
  end
end
