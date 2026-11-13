defmodule Aoc.Y2025.D9 do
  import Aoc.Util

  @type coord() :: {pos_integer(), pos_integer()}

  @spec combination_2([t]) :: [{t, t}] when t: var
  def combination_2(list) when length(list) < 2, do: []

  def combination_2([hd | tl]) do
    for(elem <- tl, do: {hd, elem}) ++ combination_2(tl)
  end

  @spec get_size(coord(), coord()) :: pos_integer()
  def get_size({a_col, a_row}, {b_col, b_row}) do
    top_left_col = min(a_col, b_col)
    top_left_row = min(a_row, b_row)

    bottom_right_col = max(a_col, b_col)
    bottom_right_row = max(a_row, b_row)

    d_col = bottom_right_col - top_left_col + 1
    d_row = bottom_right_row - top_left_row + 1

    d_col * d_row
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    parse_input(input)
    |> Enum.map(fn row ->
      String.split(row, ",")
      |> Enum.map(&String.to_integer/1)
      |> then(&List.to_tuple/1)
    end)
    |> combination_2()
    |> Enum.map(fn {a, b} -> get_size(a, b) end)
    |> Enum.max()
  end

  @spec get_compressed_range_map([integer()]) :: %{integer() => integer()}
  def get_compressed_range_map(range) do
    Enum.reduce(range, {Map.new(), -1, -1}, fn pos, {map, last_pos, last_num} ->
      {new_map, max_num} =
        if pos - last_pos > 1 do
          # if range is larger than 1 ex: 1 -> 3 instead of 1 -> 2
          new_map =
            (last_pos + 1)..(pos - 1)
            |> Enum.reduce(map, fn p, acc ->
              Map.put(acc, p, last_num + 1)
            end)

          {
            Map.put(new_map, pos, last_num + 2),
            last_num + 2
          }
        else
          {
            Map.put(map, pos, last_num + 1),
            last_num + 1
          }
        end

      {new_map, pos, max_num}
    end)
    # append +1, represent other end's value
    |> then(fn {map, last_pos, last_num} ->
      Map.put(map, last_pos + 1, last_num + 1)
    end)
  end

  @spec get_adjacents(coord(), {pos_integer(), pos_integer()}) :: [coord()]
  def get_adjacents({col, row}, {max_col, max_row}) do
    [
      {col - 1, row},
      {col + 1, row},
      {col, row - 1},
      {col, row + 1}
    ]
    |> Enum.filter(fn {c, r} ->
      c in 0..max_col and r in 0..max_row
    end)
  end

  @spec is_pair_valid?({coord(), coord()}, MapSet.t(coord())) :: boolean()
  def is_pair_valid?({{a_col, a_row}, {b_col, b_row}}, invalid_set) do
    fns = [&min/2, &max/2]
    [min_col, max_col] = Enum.map(fns, &apply(&1, [a_col, b_col]))
    [min_row, max_row] = Enum.map(fns, &apply(&1, [a_row, b_row]))

    vertical_line_pos =
      for(c <- [min_col, max_col], r <- min_row..max_row, do: {c, r}) |> MapSet.new()

    horizontal_line_pos =
      for(c <- min_col..max_col, r <- [min_row, max_row], do: {c, r}) |> MapSet.new()

    MapSet.disjoint?(invalid_set, MapSet.union(vertical_line_pos, horizontal_line_pos))
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    corners =
      parse_input(input)
      |> Enum.map(fn row ->
        String.split(row, ",")
        |> Enum.map(&String.to_integer/1)
      end)

    # col, row compression
    [col_range, row_range] =
      Enum.zip(corners)
      |> Enum.map(fn ranges ->
        Tuple.to_list(ranges)
        |> Enum.sort()
        |> Enum.uniq()
      end)

    [new_col_map, new_row_map] = Enum.map([col_range, row_range], &get_compressed_range_map/1)

    boundary =
      [new_col_map, new_row_map]
      |> Enum.map(&(Map.values(&1) |> Enum.max()))
      |> List.to_tuple()

    [inverse_col_map, inverse_row_map] =
      Enum.map([new_col_map, new_row_map], &(Enum.map(&1, fn {k, v} -> {v, k} end) |> Map.new()))

    compressed_corners =
      Enum.map(corners, fn [col, row] ->
        {new_col_map[col], new_row_map[row]}
      end)

    compressed_polygon_pos_set =
      (compressed_corners ++ [hd(compressed_corners)])
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(MapSet.new(), fn [{a_col, a_row}, {b_col, b_row}], acc_set ->
        fns = [&min/2, &max/2]

        line_pos_set =
          if a_row == b_row do
            # horizontal
            [min_col, max_col] = Enum.map(fns, &apply(&1, [a_col, b_col]))

            min_col..max_col
            |> Enum.map(&{&1, a_row})
            |> MapSet.new()
          else
            # vertical
            [min_row, max_row] = Enum.map(fns, &apply(&1, [a_row, b_row]))

            min_row..max_row
            |> Enum.map(&{a_col, &1})
            |> MapSet.new()
          end

        MapSet.union(acc_set, line_pos_set)
      end)

    # flood fill from 0, 0 to mark as invalid position
    invalid_pos_set =
      Enum.reduce_while(
        Stream.repeatedly(fn -> nil end),
        {MapSet.new([{0, 0}]), [{0, 0}]},
        fn _, {visited_set, candidates} ->
          to_explore_candidates =
            Enum.flat_map(candidates, &get_adjacents(&1, boundary))
            |> Enum.reject(
              &(MapSet.member?(visited_set, &1) or MapSet.member?(compressed_polygon_pos_set, &1))
            )
            |> MapSet.new()

          next_visited_set = MapSet.union(visited_set, to_explore_candidates)

          if MapSet.size(to_explore_candidates) == 0 do
            {:halt, visited_set}
          else
            {:cont, {next_visited_set, to_explore_candidates}}
          end
        end
      )

    # find pair that yield most while all pos in rect is valid
    compressed_corners
    |> combination_2()
    |> Enum.filter(&is_pair_valid?(&1, invalid_pos_set))
    |> Enum.map(fn {{pa_col, pa_row}, {pb_col, pb_row}} ->
      a = {
        inverse_col_map[pa_col],
        inverse_row_map[pa_row]
      }

      b = {
        inverse_col_map[pb_col],
        inverse_row_map[pb_row]
      }

      get_size(a, b)
    end)
    |> Enum.max()
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
