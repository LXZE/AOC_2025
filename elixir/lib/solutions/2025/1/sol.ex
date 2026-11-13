defmodule Aoc.Y2025.D1 do
  import Aoc.Util

  @spec parse_line(String.t()) :: {String.t(), integer()}
  def parse_line(line) do
    {op, num_str} = String.split_at(line, 1)
    num = Integer.parse(num_str) |> elem(0)
    {op, num}
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    parse_input(input)
    |> Enum.reduce({50, 0}, fn item, {curr_pointer, answer} ->
      {op, num} = parse_line(item)

      new_pointer =
        case op do
          "L" -> curr_pointer - num
          "R" -> curr_pointer + num
        end
        |> Integer.mod(100)

      {new_pointer, answer + if(new_pointer == 0, do: 1, else: 0)}
    end)
    |> elem(1)
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    parse_input(input)
    |> Enum.reduce({50, 0}, fn item, {curr_pointer, answer} ->
      {op, num} = parse_line(item)

      over_0_count = div(num, 100)
      num = rem(num, 100)

      curr_pointer = if op == "L" and curr_pointer == 0, do: 100, else: curr_pointer

      new_pointer =
        case op do
          "L" -> curr_pointer - num
          "R" -> curr_pointer + num
        end

      {new_pointer, over_0_count_2} =
        if new_pointer >= 100 or new_pointer <= 0 do
          {Integer.mod(new_pointer, 100), 1}
        else
          {new_pointer, 0}
        end

      {new_pointer, answer + over_0_count + over_0_count_2}
    end)
    |> elem(1)
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
