defmodule RailFenceCipher do
  @doc """
  Encode a given plaintext to the corresponding rail fence ciphertext
  """
  @spec encode(String.t, pos_integer) :: String.t
  def encode(str, rails_num) do
    rails_indexes = prepare_rails(str, [], 0, 1, rails_num)

    str
    |> String.graphemes
    |> Enum.with_index
    |> Enum.reduce(List.duplicate([], rails_num), fn({s, i}, acc) ->
      List.update_at(acc, Enum.at(rails_indexes, i), fn(x) -> [s | x ] end)
    end)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.join
  end

  defp prepare_rails("", acc, _, _, _), do: Enum.reverse(acc)
  defp prepare_rails(<<char::binary-1, str::binary>>, acc, rails_index, direction, rails_num) do
    new_acc = [rails_index | acc]

    next_direction = cond do
      rails_num == 1 -> 0
      rails_index == (rails_num - 1) -> -1
      rails_index == 0     -> 1
      true                 -> direction
    end

    next_rails_index = rails_index + next_direction

    prepare_rails(str, new_acc, next_rails_index, next_direction, rails_num)
  end

  @doc """
  Decode a given rail fence ciphertext to the corresponding plaintext
  """
  @spec decode(String.t, pos_integer) :: String.t
  def decode(str, rails_num) do
    rails_map = prepare_rails(str, [], 0, 1, rails_num)

    rails_lengths = Enum.reduce(rails_map, List.duplicate(0, rails_num), fn(x, acc) ->
      List.update_at(acc, x, fn(i) -> i + 1 end)
    end)

    {rails, ''} = Enum.map_reduce(rails_lengths, to_char_list(str), fn(x, acc) ->
      Enum.split(acc, x)
    end)

    put_it_back_together(rails_map, rails, [])
    |> Enum.reverse
    |> List.to_string
  end

  defp put_it_back_together([], _, acc), do: acc
  defp put_it_back_together([ri | rails_map], rails, acc) do
    [char | rest] = Enum.at(rails, ri)
    new_rails = List.replace_at(rails, ri, rest)
    put_it_back_together(rails_map, new_rails, [char | acc])
  end
end
