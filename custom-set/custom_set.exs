defmodule CustomSet do
  @opaque t :: %__MODULE__{items: list}
  defstruct items: []

  @spec new(Enum.t) :: t
  def new(enumerable) do
    %__MODULE__{items: Enum.to_list(enumerable) |> Enum.uniq}
  end

  @spec empty?(t) :: boolean
  def empty?(custom_set) do
    length(custom_set.items) == 0
  end

  @spec contains?(t, any) :: boolean
  def contains?(custom_set, element) do
    Enum.any?(custom_set.items, fn(i)-> i == element end)
  end

  @spec subset?(t, t) :: boolean
  def subset?(custom_set_1, custom_set_2) do
    Enum.all?(custom_set_1.items, fn (item)-> contains?(custom_set_2, item) end)
  end

  @spec disjoint?(t, t) :: boolean
  def disjoint?(custom_set_1, custom_set_2) do
    !Enum.any?(custom_set_1.items, fn (item)-> contains?(custom_set_2, item) end)
  end

  @spec equal?(t, t) :: boolean
  def equal?(custom_set_1, custom_set_2) do
    Enum.sort(custom_set_1.items) == Enum.sort(custom_set_2.items)
  end

  @spec add(t, any) :: t
  def add(custom_set, element) do
    {old_value, new_set} = Map.get_and_update(custom_set, :items, fn(current)-> {current, Enum.uniq([element | current])} end)
    new_set
  end

  @spec intersection(t, t) :: t
  def intersection(custom_set_1, custom_set_2) do
    new(Enum.filter(custom_set_1.items, fn (item)-> contains?(custom_set_2, item) end))
  end

  @spec difference(t, t) :: t
  def difference(custom_set_1, custom_set_2) do
    new(Enum.reject(custom_set_1.items, fn (item)-> contains?(custom_set_2, item) end))
  end

  @spec union(t, t) :: t
  def union(custom_set_1, custom_set_2) do
    new(custom_set_1.items ++ custom_set_2.items)
  end
end
