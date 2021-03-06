defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """

  @spec parse(String.t) :: String.t
  def parse(markdown) do

    String.split(markdown, "\n")
    |> Enum.chunk_by(&String.first/1)
    |> Enum.map(&process/1)
    |> Enum.join
  end

  defp process(["*" <> _ | _] = lines) do
    "<ul>#{
      Enum.map(lines, fn("* " <> line)->
        "<li>#{do_inlines(line)}</li>"
      end)
    }</ul>"
  end

  defp process(lines) do
    lines
    |> Enum.map(&do_inlines/1)
    |> Enum.map(&wrap/1)
  end

  defp wrap("#" <> _ = markdown) do
    [_, pounds, copy] = Regex.run(~r/^(#+) (.+)/, markdown)
    h_num = String.length(pounds)
    "<h#{h_num}>#{copy}</h#{h_num}>"
  end

  defp wrap(markdown) do
    "<p>#{markdown}</p>"
  end

  defp do_inlines(markdown) do
    trans = [
      __: "em",
      _: "i"
    ]

    trans
    |> Enum.reduce(markdown, fn({k, v}, acc) -> do_inlines(acc, Atom.to_string(k), v) end)
  end

  defp do_inlines(markdown, lf, tag_name) do
    String.replace(markdown, ~r/#{lf}(.+)#{lf}/, "<#{tag_name}>\\1</#{tag_name}>")
  end
end
