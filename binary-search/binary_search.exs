defmodule BinarySearch do
  @doc """
    Searches for a key in the list using the binary search algorithm.
    It returns :not_found if the key is not in the list.
    Otherwise returns the tuple {:ok, index}.

    ## Examples

      iex> BinarySearch.search([], 2)
      :not_found

      iex> BinarySearch.search([1, 3, 5], 2)
      :not_found

      iex> BinarySearch.search([1, 3, 5], 5)
      {:ok, 2}

  """

  @spec search(Enumerable.t, integer) :: {:ok, integer} | :not_found
  def search(list, key) do
    if length(list) > 2 and hd(list) > List.last(list) do
      raise ArgumentError, message: "expected list to be sorted"
    end

    bsearch(list, key)
  end

  def bsearch([], key, offset), do: :not_found
  def bsearch(list, key, offset \\ 0) do
    list_length = length(list)
    index = div(list_length, 2)
    item = Enum.at(list, index)

    cond do
      item == key -> {:ok, index + offset}
      item < key -> bsearch(Enum.slice(list, index + 1, list_length), key, index + 1)
      item > key -> bsearch(Enum.slice(list, 0, index), key)
    end
  end
end
