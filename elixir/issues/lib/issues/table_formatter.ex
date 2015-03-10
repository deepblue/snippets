defmodule Issues.TableFormatter do
  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  def print_table(rows, headers) do
    data = split(rows, headers)
    widths = widths_of(data)
    format = format_for(widths)

    puts_line headers, format
    IO.puts separator(widths)
    puts data, format
  end

  def split(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(data) do
    for d <- data, do: d |> map(&String.length/1) |> max
  end

  def format_for(widths) do
    map_join(widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(widths) do
    map_join(widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts(data, format) do
    data
      |> List.zip
      |> map(&Tuple.to_list/1)
      |> each(&puts_line(&1, format))
  end

  def puts_line(line, format) do
    :io.format(format, line)
  end
end
