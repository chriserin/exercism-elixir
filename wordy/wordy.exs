defmodule Wordy do

  @symbols %{
    "multiplied by" => &*/2,
    "divided by" => &div/2,
    "plus" => &+/2,
    "minus" => &-/2
  }

  def answer("Who is " <> question) do
    raise ArgumentError
  end

  def answer("What is " <> question) do
    ast = parse(question)
    execute(ast)
  end

  defp execute(collapsed_ast) when length(collapsed_ast) == 1, do: hd(collapsed_ast)
  defp execute([n | ast]) when rem(length(ast), 2) == 0 do
    [operation, arg | rest] = ast
    execute([ operation.(n, arg) | rest ])
  end

  defp execute([n | ast]) when rem(length(ast), 2) == 1 do
    raise ArgumentError, message: "no unary operations currently"
  end

  def get_op(symbol) do
    case Map.fetch(@symbols, symbol) do
      {:ok, value} -> value
      :error -> :placeholder
    end
  end

  defp parse(question) do
    question
    |> String.replace("What is ", "")
    |> String.replace("?", "")
    |> String.split(~r/[-\d]+/, include_captures: true, trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(fn(symbol) -> 
      case Integer.parse(symbol) do
        :error ->
          get_op(symbol)
        {value, _} ->
          value
      end
    end)
  end
end
