defmodule Aoc.Y2025.D12 do
  import Aoc.Util

  @spec part1(String.t()) :: any()
  def part1(input) do
    raws =
      parse_input(input)
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(length(&1) == 1))

    {rules, shapes} = List.pop_at(raws, -1)

    shapes_volumes =
      Enum.map(shapes, fn [_ | tl] ->
        Enum.join(tl) |> String.count("#")
      end)

    Enum.count(rules, fn rule ->
      [h, w | req] =
        Regex.scan(~r/\d+/, rule)
        |> Enum.map(fn [e] -> String.to_integer(e) end)

      volumes =
        Enum.zip(req, shapes_volumes)
        |> Enum.sum_by(fn {count, shape_vol} -> count * shape_vol end)

      h * w > volumes
    end)
  end

  @spec part2(String.t()) :: any()
  def part2(_input) do
    :ok
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
