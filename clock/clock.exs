defmodule Clock do
  defstruct hour: 0, minute: 0

  @doc """
  Returns a string representation of a clock:

      iex> Clock.new(8, 9) |> to_string
      "08:09"
  """
  @spec new(integer, integer) :: Clock
  def new(hour, minute) do
    calc_total_minutes(hour, minute)
    |> clock_from_total_minutes
  end

  defp clock_from_total_minutes(total_minutes) do
    new_hour = rem(div(total_minutes, 60), 24)
    new_minute = rem(total_minutes, 60)

    %Clock{hour: new_hour, minute: new_minute}
  end

  defp calc_total_minutes(hour, minute) do
    total_minutes = 60 * hour + minute

    case total_minutes < 0 do
      true ->
        60 * 24 + rem(total_minutes, 60 * 24)
      false ->
        total_minutes
    end
  end

  @doc """
  Adds two clock times:

      iex> Clock.add(10, 0) |> Clock.add(3) |> to_string
      "10:03"
  """
  @spec add(Clock, integer) :: Clock
  def add(%Clock{hour: hour, minute: minute}, add_minute) do
    total_minutes = calc_total_minutes(hour, minute)
    |> fn(a) -> a + add_minute end.()

    total_minutes = case total_minutes < 0 do
      true -> rem(total_minutes, 24 * 60) + 24 * 60
      false -> total_minutes
    end
    clock_from_total_minutes(total_minutes)
  end
end

defimpl String.Chars, for: Clock do
  def to_string(clock) do
    "#{pad_value(clock.hour)}:#{pad_value(clock.minute)}"
  end

  def pad_value(v) do
    String.rjust(Integer.to_string(v), 2, ?0)
  end
end
