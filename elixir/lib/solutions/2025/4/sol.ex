defmodule Aoc.Y2025.D4 do
  import Aoc.Util

  @typedoc "A position is a tuple represent as {row, col}"
  @type position() :: {integer(), integer()}

  @typedoc "A grid is a nested list of string representing each cell"
  @type grid() :: list(list(String.t()))

  @spec get_adjacents(position(), position()) ::
          list(position())
  def get_adjacents({row, col}, {max_row, max_col}) do
    for r <- (row - 1)..(row + 1), c <- (col - 1)..(col + 1) do
      {r, c}
    end
    |> Enum.filter(fn {r, c} ->
      r in 0..(max_row - 1) and c in 0..(max_col - 1) and {r, c} != {row, col}
    end)
  end

  @spec can_remove?(grid(), position(), position()) :: boolean()
  def can_remove?(map, {row, col}, {max_row, max_col}) do
    case get_in(map, [Access.at(row), Access.at(col)]) do
      "." ->
        false

      "@" ->
        get_adjacents({row, col}, {max_row, max_col})
        |> Enum.filter(fn {adj_row, adj_col} ->
          get_in(map, [adj_row, adj_col] |> Enum.map(&Access.at/1)) == "@"
        end)
        |> length()
        |> then(&(&1 < 4))
    end
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    map = parse_input(input) |> Enum.map(&String.graphemes/1)
    max_row = length(map)
    max_col = length(Enum.at(map, 0))
    map_prop = {max_row, max_col}

    for row <- 0..(max_row - 1), col <- 0..(max_col - 1) do
      can_remove?(map, {row, col}, map_prop)
    end
    |> Enum.count(& &1)
  end

  @spec update_map(grid(), list(position())) :: any()
  def update_map(map, cells) do
    Enum.reduce(cells, map, fn {row, col}, acc ->
      put_in(acc, [row, col] |> Enum.map(&Access.at/1), ".")
    end)
  end

  @spec get_removable(grid(), position()) :: integer()
  def get_removable(map, {max_row, max_col} = map_prop) do
    to_update_data =
      for row <- 0..(max_row - 1), col <- 0..(max_col - 1) do
        {can_remove?(map, {row, col}, map_prop), {row, col}}
      end
      |> Enum.filter(&elem(&1, 0))

    if length(to_update_data) == 0 do
      0
    else
      length(to_update_data) +
        get_removable(
          update_map(map, to_update_data |> Enum.map(&elem(&1, 1))),
          map_prop
        )
    end
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    map = parse_input(input) |> Enum.map(&String.graphemes/1)
    max_row = length(map)
    max_col = length(Enum.at(map, 0))

    get_removable(map, {max_row, max_col})
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
