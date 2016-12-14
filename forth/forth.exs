defmodule Forth do
  @opaque evaluator :: any

  @doc """
  Create a new evaluator.
  """
  @spec new() :: evaluator
  def new() do
    {[], []}
  end

  @doc """
  Evaluate an input string, updating the evaluator state.
  """
  @spec eval(evaluator, String.t) :: evaluator
  def eval({existing_stack, existing_registry}, s) do
    String.split(s, ~r/[^€:;\w\d+*-\/]/u)
    |> Enum.map(&String.upcase/1)
    |> Enum.map(fn(frame) ->
      case frame =~ ~r/\d+/ do
        true ->
          String.to_integer(frame)
        false ->
          frame
      end
    end)
    |> Enum.reduce({Enum.reverse(existing_stack), existing_registry, false}, fn (frame, {stack, registry, is_defining}) ->
      cond do
        frame == ";" ->
          [current_forth_fn | other_forth_fns] = registry
          {stack, [Enum.reverse(current_forth_fn) | other_forth_fns], false}
        is_defining ->
          [current_forth_fn | other_forth_fns] = registry
          case length(current_forth_fn) == 0 and not is_binary(frame) do
            true -> raise Forth.InvalidWord
            false -> nil
          end
          {stack, [[frame | current_forth_fn] | other_forth_fns], true}
        frame == ":" ->
          {stack, [[] | registry], true}
        frame in Enum.map(registry, &hd/1) ->
          {Enum.reverse(tl(Enum.find(registry, fn(forth_fn) -> hd(forth_fn) == frame end))) ++ stack, registry, false}
        frame in ["DUP", "DROP", "SWAP", "OVER", "/", "+", "-", "*"] or is_integer(frame) ->
          {build_stack(frame, stack), registry, false}
        true ->
          raise Forth.UnknownWord
      end
    end)
    |> fn({stack, registry, _}) ->
      {Enum.reverse(stack), registry}
    end.()
  end

  defp build_stack(frame, []) when frame in ["DUP", "DROP"], do: raise Forth.StackUnderflow
  defp build_stack(frame, stack) when length(stack) < 2 and frame in ["SWAP", "OVER"], do: raise Forth.StackUnderflow
  defp build_stack("/", [<<potential_op, _::binary>> | rest]) when potential_op in '+/-*', do: raise Forth.DivisionByZero
  defp build_stack(frame, stack), do: [frame | stack]

  @doc """
  Return the current stack as a string with the element on top of the stack
  being the rightmost element in the string.
  """
  @spec format_stack(evaluator) :: String.t
  def format_stack({stack, _}) do
    Enum.reduce(stack, [], fn(frame, acc)->
      perform_operation(frame, acc)
      |> List.wrap
    end)
    |> Enum.reverse
    |> Enum.join(" ")
  end

  defp perform_operation("DUP", stack) do
    [stack_bottom | rest_of_stack] = stack
    [stack_bottom | stack]
  end

  defp perform_operation("DROP", stack) do
    [stack_bottom | rest_of_stack] = stack
    rest_of_stack
  end

  defp perform_operation("SWAP", stack) do
    [stack_bottom, next | rest_of_stack] = stack
    [next, stack_bottom | rest_of_stack]
  end

  defp perform_operation("OVER", stack) do
    [stack_bottom, next | rest_of_stack] = stack

    [next, stack_bottom, next | rest_of_stack]
  end

  defp perform_operation(<<char, _::binary>> = op, stack) when char in '*+/-' do
    process_stack = Enum.reverse(stack)
    [stack_bottom | rest_of_stack] = process_stack

    cond do
      op == "*" -> Enum.reduce(rest_of_stack, stack_bottom, fn(frame, mult_acc)-> frame * mult_acc end)
      op == "/" -> Enum.reduce(rest_of_stack, stack_bottom, fn(frame, div_acc)-> div(div_acc, frame) end)
      op == "+" -> Enum.reduce(process_stack, 0, fn(frame, mult_acc)-> frame + mult_acc end)
      op == "-" -> Enum.reduce(rest_of_stack, stack_bottom, fn(frame, minus_acc)-> minus_acc - frame end)
    end
    |> List.wrap
  end

  defp perform_operation(frame, stack) when not is_integer(frame) do
    perform_operation(String.upcase(frame), stack)
  end

  defp perform_operation(frame, stack) do
    [frame | stack]
  end

  defmodule StackUnderflow do
    defexception []
    def message(_), do: "stack underflow"
  end

  defmodule InvalidWord do
    defexception [word: nil]
    def message(e), do: "invalid word: #{inspect e.word}"
  end

  defmodule UnknownWord do
    defexception [word: nil]
    def message(e), do: "unknown word: #{inspect e.word}"
  end

  defmodule DivisionByZero do
    defexception []
    def message(_), do: "division by zero"
  end
end
