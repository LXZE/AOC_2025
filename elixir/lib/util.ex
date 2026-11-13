defmodule Aoc.Util do
  def parse_lines(input, splitter \\ "\n") do
    input
    |> String.trim()
    |> String.split(splitter)
  end
end
