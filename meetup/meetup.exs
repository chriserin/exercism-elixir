defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @days ~w(monday tuesday wednesday thursday friday saturday sunday)a
  @date_ranges [teenth: 13..19, first: 1..7, second: 8..14, third: 15..21, fourth: 22..31]

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    day = Enum.find(1..31, fn(day) -> match_criteria({year, month, day}, weekday, schedule) end)
    {year, month, day}
  end

  defp match_criteria(date, weekday, schedule) do
    :calendar.valid_date(date)
    &&
    Enum.at(@days, :calendar.day_of_the_week(date) - 1) == weekday
    &&
    match_schedule(date, schedule)
  end


  defp match_schedule(date, schedule) do
    day = elem(date, 2)
    month = elem(date, 1)
    year = elem(date, 0)
    case schedule do
      :last -> :calendar.last_day_of_the_month(year, month) - 7 < day
      s -> Enum.member?(@date_ranges[s], day)
    end
  end
end
