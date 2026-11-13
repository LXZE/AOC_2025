defmodule Aoc.Y2025.D5 do
  import Aoc.Util

  @spec get_data(String.t()) :: {[Range.t()], [integer()]}
  def get_data(input) do
    [ranges, _, nums] =
      parse_input(input)
      |> Enum.chunk_by(&(&1 == ""))

    ranges =
      Enum.map(ranges, fn r_str ->
        [a, b] =
          String.split(r_str, "-")
          |> Enum.map(&String.to_integer/1)

        a..b//1
      end)

    nums = Enum.map(nums, &String.to_integer/1)
    {ranges, nums}
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    {ranges, nums} = get_data(input)

    Enum.count(nums, fn num ->
      Enum.any?(ranges, &(num in &1))
    end)
  end

  @spec recursive_merges([Range.t()]) :: [Range.t()]
  def recursive_merges([]), do: []

  def recursive_merges([a..b//1 = head_range | tail_ranges]) do
    mergable_idx =
      Enum.find_index(tail_ranges, fn range ->
        a in range or b in range
      end)

    if mergable_idx == nil do
      [head_range] ++ recursive_merges(tail_ranges)
    else
      List.update_at(
        tail_ranges,
        mergable_idx,
        fn p..q//1 ->
          min(a, p)..max(b, q)
        end
      )
      |> recursive_merges()
    end
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    {ranges, _} = get_data(input)

    ranges
    # always find from small to large, preventing missing merges
    |> Enum.sort_by(&Range.size/1)
    |> recursive_merges()
    |> Enum.sum_by(&Range.size/1)
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
