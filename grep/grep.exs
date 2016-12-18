defmodule Grep do

  @spec grep(String.t, [String.t], [String.t]) :: String.t
  def grep(pattern, flags, files) do
    flags = if(length(files) > 1, do: ["-f" | flags], else: flags)

    files
    |> Enum.map(fn(file) ->
      read_file(file, flags)
    end)
    |> List.flatten
    |> Enum.filter(fn(line)-> 
      match_line(line, pattern, flags)
    end)
    |> Enum.filter(fn(line)-> match_entire_line(line, pattern, flags) end)
    |> Enum.filter(fn({line, file})-> line != "" end)
    |> Enum.map(fn(line)-> report_line(line, flags) end)
    |> Enum.uniq
    |> Enum.join("\n")
    |> String.trim
    |> fn(output)->
      case output == "" do
        true ->
          output
        false ->
          output <> "\n"
      end
    end.()
  end

  defp read_file(file, flags) do
    File.read!(file)
    |> String.split(~r/\R/)
    |> add_line_numbers(file, flags)
  end

  defp add_line_numbers(lines, file, flags) do
    case "-n" in flags do
      true ->
        lines
        |> Enum.with_index
        |> Enum.map(fn({line, index})-> {"#{index + 1}:#{line}", file} end)
      false ->
        lines
        |> Enum.map(fn(line)-> {line, file} end)
    end
    |> Enum.map(fn({line, file})-> {String.trim(line), file} end)
  end

  defp match_line({line, _}, pattern, flags) do
    case "-i" in flags do
      true ->
        line =~ ~r/#{pattern}/i
      false ->
        line =~ pattern
    end
    |> fn(value) ->
      case "-v" in flags do
        true -> !value
        false -> value
      end
    end.()
  end

  defp match_entire_line({line, _}, pattern, flags) do
    line_without_number = String.replace(line, ~r/^\d:/, "")
    case "-x" in flags and not "-v" in flags do
      true ->
        line_without_number =~ ~r/^#{pattern}$/i
      false ->
        true
    end
  end

  defp report_line({line, file}, flags) do
    line = case "-l" in flags do
      true ->
        file
      false ->
        line
    end

    case "-f" in flags and not "-l" in flags do
      true ->
        "#{file}:#{line}"
      false ->
        line
    end
  end
end
