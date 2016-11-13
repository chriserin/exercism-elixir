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

  def reduce_game_to_frames(game) do
    Enum.reverse(game)
    |> Enum.reduce([], fn(roll, frames)->
      current_frame = List.first(frames)
      cond do
        is_nil(current_frame) -> [{roll} | frames]
        tuple_size(current_frame) == 1 and current_frame == {10} -> [{roll} | frames]
        tuple_size(current_frame) == 2 -> [{roll} | frames]
        tuple_size(current_frame) == 1 ->
          [{r1} | rest] = frames
          [{r1, roll} | rest]
      end
    end)
  end

  defp flatten

  def roll(game, roll), do: {:error, "Pins must have a value from 0 to 10"}

  def score(game) do
    frames = reduce_game_to_frames(game) |> Enum.reverse
    cond do
      length(frames) < 10 -> {:error, "Score cannot be taken until the end of the game"}
      length(frames) > 10 && Enum.sum(Tuple.to_list(Enum.at(frames, 9))) != 10 -> {:error, "Invalid game: too many frames"}
      true -> reduce_game(Enum.reverse(game), 0, 0, 1)
    end
  end

  defp reduce_game([10, 10], bonuses, score, 11), do: score + 10 * bonuses
  defp reduce_game([r1, r2], bonuses, score, 11), do: score + r1 + r2
  defp reduce_game([], bonuses, score, frames), do: score
  defp reduce_game([r1, r2], _, _, 10) when r1 + r2 == 10, do: {:error, "Score cannot be taken until the end of the game"}
  defp reduce_game([10, _], _, _, 10), do: {:error, "Score cannot be taken until the end of the game"}
  defp reduce_game([r1, r2 | rolls], bonuses, score, frames) do
    cond do
      r1 == 10 ->
        reduce_game([r2 | rolls], bonuses_for_strike(bonuses), score + apply_bonuses(r1, bonuses), frames + 1)
      true ->
        spare_bonus = if(r1 + r2 == 10, do: 1 , else: 0)
        reduce_game(rolls, Enum.max([0, bonuses - 2]) + spare_bonus, score + apply_bonuses(r1, r2, bonuses), frames + 1)
    end
  end

  defp reduce_game([r1], bonuses, score, 11), do: score + r1

  defp reduce_game([10], _, _, 10) do
    {:error, "Score cannot be taken until the end of the game"}
  end


  defp bonuses_for_strike(bonuses) do
    if bonuses > 0 do
      3
    else
      2
    end
  end

  defp apply_bonuses(r1, bonuses) do
    cond do
      bonuses >= 3 ->
        r1 * 3
      bonuses == 2 ->
        r1 * 2
      bonuses == 1 ->
        r1 * 2
      bonuses == 0 ->
        r1
    end
  end

  defp apply_bonuses(r1, r2, bonuses) do
    cond do
      bonuses >= 3 ->
        r1 * 3 + r2 * 2
      bonuses == 2 ->
        r1 * 2 + r2 * 2
      bonuses == 1 ->
        r1 * 2 + r2
      bonuses == 0 ->
        r1 + r2
    end
  end
end
