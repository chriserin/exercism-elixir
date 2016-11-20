defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
end

defmodule Dot do
  defmacro graph(ast) do
    check_for_errors(ast)
    x = nodes(ast)
    y = edges(ast)
    z = attrs(ast)

    quote do
      %Graph{nodes: unquote(x), edges: unquote(y), attrs: unquote(z)}
    end
  end

  defp check_for_errors([do: lines]) when is_list(lines), do: raise ArgumentError, "gotta start right"
  defp check_for_errors([do: lines]), do: check_for_errors(lines)
  defp check_for_errors({{:., _, _}, _, _}), do: raise ArgumentError, "invalid access get"
  defp check_for_errors(poss_int) when is_integer(poss_int), do: raise ArgumentError, "integer"
  defp check_for_errors({_, _, args}), do: check_for_errors(args)
  defp check_for_errors(nil), do: :all_good
  defp check_for_errors([]), do: :all_good
  defp check_for_errors(lines) when is_list(lines) do
    Enum.each(lines, fn(line)->
      if is_list(line) and is_binary(List.first(line)) do
        raise ArgumentError, "non-keyword list"
      end
      check_for_errors(line)
    end)
  end
  defp check_for_errors(_), do: :all_good

  defp nodes([do: {:__block__, _, ast}]), do: nodes(ast)
  defp nodes([do: ast]), do: nodes([ast])
  defp nodes(ast) do
    ast
    |> Enum.reject(fn(v) -> is_nil(v) end)
    |> Enum.reject(fn({function_name, context, args}) -> function_name == :-- end)
    |> Enum.reject(fn({function_name, context, args}) -> function_name == :graph end)
    |> Enum.map(fn({function_name, context, args}) ->
      node_value = List.first(List.wrap(args))

      node_value = cond do
        is_nil(node_value) -> []
        true -> node_value
      end

      {function_name, node_value}
    end)
    |> Enum.sort
  end

  defp edges([do: {:__block__, _, ast}]), do: edges(ast)
  defp edges([do: ast]), do: edges([ast])
  defp edges(ast) do
    ast
    |> Enum.reject(&is_nil/1)
    |> Enum.filter(fn({function_name, context, args}) -> function_name == :-- end)
    |> Enum.map(fn({function_name, context, args}) ->
      cond do
        function_name == :-- ->
          edge_args(args)
        true ->
          []
      end
    end)
    |> Enum.sort
  end

  defp edge_args(args) do
    args
    |> Enum.map(fn ({n, context, args})->
      n
    end)
    |> Enum.sort
    |> List.insert_at(-1, edge_arg_attrs(args))
    |> List.to_tuple
    |> Macro.escape
  end

  defp edge_arg_attrs(args) do
    args
    |> Enum.map(fn ({n, context, edge_args})->
      edge_args
    end)
    |> List.flatten
    |> Enum.reject(&is_nil/1)
  end

  defp attrs([do: {:__block__, _, ast}]), do: attrs(ast)
  defp attrs([do: ast]), do: attrs([ast])

  defp attrs(ast) do
    ast
    |> Enum.reject(fn(v) -> is_nil(v) end)
    |> Enum.filter(fn({function_name, context, args}) -> function_name == :graph end)
    |> Enum.map(fn({function_name, context, args}) ->
      args
    end)
    |> List.flatten
    |> Enum.sort
  end
end
