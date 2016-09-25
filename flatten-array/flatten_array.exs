defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list), do: flatten(list, [])
  def flatten([], [nil])
  def flatten([], acc), do: Enum.reverse(acc)
  def flatten([[]], acc), do: Enum.reverse(acc)
  def flatten([nil | list], acc), do: flatten(list, acc)
  def flatten([[] | list], acc), do: flatten(list, acc)
  def flatten([[a | b] | list], acc), do: flatten(flatten([b | list]), [a | acc])
  def flatten([a | list], acc), do: flatten(list, [a | acc])
end
