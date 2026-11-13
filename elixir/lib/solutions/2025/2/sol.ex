defmodule Aoc.Y2025.D2 do
  import Aoc.Util

  @spec get_invalid_numbers(Range.t()) :: list(number())
  def get_invalid_numbers(range) do
    Enum.filter(range, fn num ->
      num_str = Integer.to_string(num)
      half = div(String.length(num_str), 2)
      {l, r} = String.split_at(num_str, half)
      l == r
    end)
  end

  @spec get_ranges(String.t()) :: list(Range.t())
  def get_ranges(input) do
    parse_input(input)
    |> hd
    |> String.split(",")
    |> Enum.map(fn line ->
      String.split(line, "-")
      |> Enum.map(&String.to_integer/1)
      |> then(fn e -> apply(&Range.new/2, e) end)
    end)
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    get_ranges(input)
    |> Enum.flat_map(&get_invalid_numbers/1)
    |> Enum.sum()
  end

  @repeat_regex ~r/^(\d+)(\1)+$/

  @spec is_invalid?(String.t()) :: boolean()
  def is_invalid?(num_str), do: Regex.match?(@repeat_regex, num_str)

  @spec get_invalid_numbers_v2(Range.t()) :: list(number())
  def get_invalid_numbers_v2(range) do
    Enum.filter(range, fn num ->
      Integer.to_string(num)
      |> is_invalid?()
    end)
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    get_ranges(input)
    |> Enum.flat_map(&get_invalid_numbers_v2/1)
    |> Enum.sum()
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
