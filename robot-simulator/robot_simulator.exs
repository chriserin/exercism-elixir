defmodule Robot do
  defstruct direction: :north, position: {0,0}
end

defmodule RobotSimulator do

  @directions [north: {0, 1}, east: {1, 0}, south: {0, -1}, west: {-1, 0}]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  @spec create(direction :: atom, position :: { integer, integer }) :: any
  def create(direction \\ :north, position \\ {0,0}) do
    cond do
      Enum.find_index(directions, &(direction == &1)) == nil ->
        {:error, "invalid direction"}
      !is_tuple(position) || !Enum.all?(Tuple.to_list(position), &(is_integer(&1))) || tuple_size(position) > 2  ->
        {:error, "invalid position"}
      true -> 
        %Robot{direction: direction, position: position}
    end
  end

  @spec simulate(robot :: any, instructions :: String.t ) :: any
  def simulate(robot, instructions) do
    cond do
      Regex.match?(~r/^[ALR]+$/, instructions) ->
        process_instructions(robot, instructions)
      true ->
        {:error, "invalid instruction"}
    end
  end

  defp process_instructions(robot, instructions) do
    instructions
    |> to_charlist
    |> Enum.reduce(robot, fn(inst, r) ->
      case inst do
        ?A -> forward(r)
        ?L -> left(r)
        ?R -> right(r)
      end
    end)
  end

  defp forward(robot) do
    {x, y} = @directions[robot.direction]
    {currentX, currentY} = robot.position
    Map.put(robot, :position, {x + currentX, y + currentY})
  end

  defp left(robot) do
    i = Enum.find_index(directions, &(&1 == robot.direction))
    Map.put(robot, :direction, Enum.at(directions, i - 1))
  end

  defp right(robot) do
    i = Enum.find_index(directions, &(&1 == robot.direction))
    Map.put(robot, :direction, Enum.at(directions, rem(i + 1, 4)))
  end

  @spec direction(robot :: any) :: atom
  def direction(robot) do
    robot.direction
  end

  @spec position(robot :: any) :: { integer, integer }
  def position(robot) do
    robot.position
  end

  defp directions do
    Keyword.keys(@directions)
  end
end
