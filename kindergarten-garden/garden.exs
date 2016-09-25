defmodule Garden do
  @plants %{
    ?V => :violets,
    ?R => :radishes,
    ?C => :clover,
    ?G => :grass
  }

  @default_names [ :alice, :bob, :charlie, :david, :eve, :fred, :ginny, :harriet, :ileana, :joseph, :kincaid, :larry ]

  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ @default_names) do
    [row1, row2] = info_string
    |> String.split("\n")
    |> Enum.map(&(Enum.chunk(to_charlist(&1), 2)))

    zip(row2, row1)
    |> List.flatten
    |> Enum.chunk(4)
    |> Enum.reduce(childrens_plants(student_names), fn(plants, acc) ->
      {child, _} = Enum.find(acc, fn({name, plants}) -> tuple_size(plants) == 0 end)
      Map.put(acc, child, List.to_tuple(name_plants(plants)))
    end)
  end

  def name_plants(plant_letters) do
    plant_letters
    |> Enum.reduce([], &(&2 ++ [Map.get(@plants, &1)]))
  end

  defp childrens_plants(names) do
    Enum.sort(names)
    |> Enum.reduce(%{}, &(Map.put(&2, &1, {})))
  end

  defp zip([], [], acc), do: Enum.reverse(acc)
  defp zip([a | list1], [b | list2], acc \\ []) do
    zip(list1, list2, [a, b | acc])
  end
end
