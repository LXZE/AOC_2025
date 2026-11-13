defmodule Aoc.Y2025.D8 do
  import Aoc.Util

  defmodule Coord do
    defstruct x: 0, y: 0, z: 0

    @type t(x, y, z) :: %Coord{x: x, y: y, z: z}
    @type t :: %Coord{x: integer(), y: integer(), z: integer()}
  end

  @spec parse_row_to_coord(String.t()) :: Coord.t()
  def parse_row_to_coord(row) do
    [x, y, z] = String.split(row, ",") |> Enum.map(&String.to_integer/1)
    %Coord{x: x, y: y, z: z}
  end

  @spec distance(Coord.t(), Coord.t()) :: float()
  def distance(c1, c2) do
    [c2.x - c1.x, c2.y - c1.y, c2.z - c1.z]
    |> Enum.map(&Integer.pow(&1, 2))
    |> Enum.sum()
    |> then(&:math.sqrt/1)
  end

  @spec combinations([any()]) :: [{any(), any()}]
  def combinations(elem) when length(elem) < 2, do: []

  def combinations([head | tail]) do
    for(elem <- tail, do: {head, elem}) ++ combinations(tail)
  end

  @spec get_data(String.t()) :: {
          [{Coord.t(), Coord.t()}],
          [float()],
          {
            %{Coord.t() => integer()},
            %{integer() => MapSet.t(Coord.t())}
          }
        }
  def get_data(input) do
    coords =
      parse_input(input)
      |> Enum.map(&parse_row_to_coord/1)

    coords_pairs = combinations(coords)

    distances = Enum.map(coords_pairs, fn {a, b} -> distance(a, b) end)

    starter =
      Enum.reduce(coords, {Map.new(), Map.new()}, fn coord, {coord_id_map, id_group_map} ->
        id = System.unique_integer()

        {
          Map.put(coord_id_map, coord, id),
          Map.put(id_group_map, id, MapSet.new([coord]))
        }
      end)

    {coords_pairs, distances, starter}
  end

  @spec get_coord_distance_zip([{Coord.t(), Coord.t()}], [float()]) :: [
          {{Coord.t(), Coord.t()}, float()}
        ]
  def get_coord_distance_zip(coords_pairs, distances) do
    Enum.zip(coords_pairs, distances)
    |> Enum.sort_by(&elem(&1, 1))
  end

  def update_state(coord_a, coord_b, {coord_id_map, id_group_map} = state) do
    group_1_id = coord_id_map[coord_a]
    group_2_id = coord_id_map[coord_b]

    # same group, no need to merge
    # merge 2 group
    if group_1_id == group_2_id do
      state
    else
      {group_1, id_group_map} = Map.pop(id_group_map, group_1_id)
      {group_2, id_group_map} = Map.pop(id_group_map, group_2_id)

      new_id = System.unique_integer()
      new_group = MapSet.union(group_1, group_2)

      {
        # all coord belongs to new id now
        Enum.reduce(new_group, coord_id_map, fn coord, map ->
          Map.put(map, coord, new_id)
        end),
        Map.put(id_group_map, new_id, new_group)
      }
    end
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    is_test = System.argv() |> hd() |> then(&(&1 == "aoc.test"))
    limit = if is_test, do: 10, else: 1000

    {coords_pairs, distances, starter} = get_data(input)

    get_coord_distance_zip(coords_pairs, distances)
    |> Stream.scan(starter, fn {{a, b}, _dist}, state -> update_state(a, b, state) end)
    |> Enum.take(limit)
    |> List.last()
    |> elem(1)
    |> Enum.map(fn {_key, val} -> MapSet.size(val) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    {coords_pairs, distances, starter} = get_data(input)

    get_coord_distance_zip(coords_pairs, distances)
    |> Enum.reduce_while(starter, fn {{a, b}, _dist}, state ->
      new_state = update_state(a, b, state)

      if map_size(elem(new_state, 1)) != 1 do
        {:cont, new_state}
      else
        {:halt, a.x * b.x}
      end
    end)
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
