defmodule Aoc.Y2025.D7 do
  import Aoc.Util

  @spec get_data(String.t()) :: [String.t()]
  def get_data(input) do
    parse_input(input)
    |> Enum.with_index()
    |> Enum.filter(fn {_, idx} -> Integer.mod(idx, 2) == 0 end)
    |> Enum.map(&elem(&1, 0))
  end

  @spec get_char_positions_set(String.t()) :: MapSet.t(pos_integer())
  @spec get_char_positions_set(String.t(), String.Chars.t()) :: MapSet.t(pos_integer())
  def get_char_positions_set(row, char \\ "\\^") do
    Regex.scan(~r/#{char}/, row, return: :index)
    |> Enum.map(fn [hd] ->
      elem(hd, 0)
    end)
    |> MapSet.new()
  end

  @spec generate_new_positions_set(MapSet.t(pos_integer())) :: MapSet.t(pos_integer())
  def generate_new_positions_set(positions_set) do
    Enum.reduce(positions_set, MapSet.new(), fn pos, acc ->
      MapSet.union(acc, MapSet.new([pos - 1, pos + 1]))
    end)
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    [start_row | remain_rows] = get_data(input)

    starter = get_char_positions_set(start_row, "S")

    Enum.reduce(remain_rows, {starter, 0}, fn row, {current_pos_set, count} ->
      selected_pos_set =
        get_char_positions_set(row)
        |> MapSet.intersection(current_pos_set)

      remain_pos_set =
        MapSet.difference(
          current_pos_set,
          selected_pos_set
        )

      new_pos_set =
        MapSet.union(
          generate_new_positions_set(selected_pos_set),
          remain_pos_set
        )

      {new_pos_set, count + MapSet.size(selected_pos_set)}
    end)
    |> elem(1)
  end

  @spec generate_new_map(%{pos_integer() => integer()}) :: %{pos_integer() => integer()}
  def generate_new_map(map) do
    Enum.reduce(map, Map.new(), fn {k, v}, acc ->
      Map.merge(
        acc,
        [{k - 1, v}, {k + 1, v}] |> Map.new(),
        fn _k, v1, v2 -> v1 + v2 end
      )
    end)
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    [start_row | remain_rows] = get_data(input)

    starter =
      get_char_positions_set(start_row, "S")
      |> Map.new(fn elem -> {elem, 1} end)

    Enum.reduce(remain_rows, starter, fn row, acc ->
      split_pos_set =
        get_char_positions_set(row)
        |> MapSet.intersection(Map.keys(acc) |> MapSet.new())

      {selected_map, remain_map} =
        Map.keys(acc)
        |> Enum.reduce({Map.new(), Map.new()}, fn key, {selected, remain} ->
          if key in split_pos_set do
            {Map.put(selected, key, acc[key]), remain}
          else
            {selected, Map.put(remain, key, acc[key])}
          end
        end)

      Map.merge(
        remain_map,
        generate_new_map(selected_map),
        fn _k, v1, v2 -> v1 + v2 end
      )
    end)
    |> Map.values()
    |> Enum.sum()
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
