defmodule Bowling do
  def start do
    []
  end

  def roll(game, roll) when roll <= 10 and roll >= 0 do
    game = [roll | game]
    frames = reduce_game_to_frames(game)

    last_frame = hd(frames)
    cond do
      Enum.sum(Tuple.to_list(last_frame)) > 10 ->
        {:error, "Pin count exceeds pins on the lane"}
      true ->
        game
    end
  end

  def roll(_, _) do
    {:error, "Pins must have a value from 0 to 10"}
  end

  def reduce_game_to_frames(game) do
    Enum.reverse(game)
    |> Enum.reduce([], fn(roll, frames)->
      current_frame = List.first(frames)
      cond do
        is_nil(current_frame) -> [{roll} | frames]
        current_frame == {10} -> [{roll} | frames]
        tuple_size(current_frame) == 2 -> [{roll} | frames]
        tuple_size(current_frame) == 1 ->
          [{r1} | rest] = frames
          [{r1, roll} | rest]
      end
    end)
  end

  def score(game) do
    frames = Enum.reverse(reduce_game_to_frames(game))

    frame10 = Enum.at(frames, 9)
    frame11 = Enum.at(frames, 10)
    frame12 = Enum.at(frames, 11)

    cond do
      length(frames) < 10 -> {:error, "Score cannot be taken until the end of the game"}
      is_spare(frame10) and length(frames) < 11 -> {:error, "Score cannot be taken until the end of the game"}
      frame10 == {10} and frame11 == {10} and is_nil(frame12) -> {:error, "Score cannot be taken until the end of the game"}
      !is_spare(frame10) and frame10 != {10} and length(frames) > 10 -> {:error, "Invalid game: too many frames"}
      true ->
        score_game(frames)
    end
  end

  defp score_game(frames) do
    [{0, 0}, {0,0} | frames]
    |> Enum.chunk(3, 1)
    |> Enum.with_index
    |> Enum.map(&frame_score/1)
    |> Enum.sum
  end

  defp frame_score({[f1, f2, f3], 11}) do
    score_with_multipliers(f3, 1, 1)
  end

  defp frame_score({[f1, f2, f3], 10}) do
    m1 = 1
    m1 = if({10} == f1, do: m1 + 1, else: m1)

    score_with_multipliers(f3, m1, 1)
  end

  defp frame_score({[f1, f2, f3], i}) do
    m1 = 1
    m1 = if({10} == f1, do: m1 + 1, else: m1)
    m1 = if({10} == f2, do: m1 + 1, else: m1)
    m1 = if(tuple_size(f2) == 2 && is_spare(f2), do: m1 + 1, else: m1)

    m2 = 1
    m2 = if({10} == f2, do: m2 + 1, else: m2)

    score_with_multipliers(f3, m1, m2)
  end

  defp score_with_multipliers({r1, r2}, m1, m2) do
    r1 * m1 + r2 * m2
  end

  defp score_with_multipliers({r1}, m1, m2), do: r1 * m1

  defp is_spare(frame) do
    Enum.sum(Tuple.to_list(frame)) == 10
  end
end
