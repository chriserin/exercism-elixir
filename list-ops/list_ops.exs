defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count(list) do
    count_reduce(list, 0)
  end

  defp count_reduce([], acc), do: acc
  defp count_reduce([a | b], acc), do: count_reduce(b, acc + 1)

  @spec reverse(list) :: list
  def reverse([]), do: []
  def reverse([], new_list), do: new_list
  def reverse([a | b], new_list \\ []) do
    reverse(b, [a | new_list])
  end

  @spec map(list, (any -> any)) :: list
  def map([], _), do: []
  def map([a | b], f) do
    [f.(a) | map(b, f)]
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], f), do: []
  def filter([a | b], f) do
    case f.(a) do
      true -> [a | filter(b, f)]
      false -> filter(b, f)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([], acc, f), do: acc
  def reduce([a | b], acc, f) do
    reduce(b, f.(a, acc), f)
  end

  @spec append(list, list) :: list
  def append([], b), do: b
  def append(a, b) do
    rappend(reverse(a), b)
  end

  defp rappend([], b), do: b
  defp rappend([x | a], b) do
    rappend(a, [x | b])
  end

  @spec concat([[any]]) :: [any]
  def concat(ll), do: concat(ll, [])
  def concat([], acc), do: reverse(acc)
  def concat([[] | ll], acc), do: concat(ll, acc)
  def concat([[a | b] | ll], acc) do
    concat([b | ll], [a | acc])
  end
  def concat([x | ll], acc), do: concat(ll, [x | acc])
end
