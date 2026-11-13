defmodule Aoc.Y2025.D6 do
  import Aoc.Util

  @spec calc([String.t()], [list(integer())]) :: number()
  def calc(ops, nums_rows) do
    Enum.zip(ops, nums_rows)
    |> Enum.map(fn {op, nums} ->
      case op do
        "+" -> Enum.sum(nums)
        "*" -> Enum.product(nums)
      end
    end)
    |> Enum.sum()
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    [ops | nums_str] =
      parse_input(input)
      |> Enum.map(&(Regex.scan(~r/\S+/, &1) |> List.flatten()))
      |> Enum.reverse()

    nums_rows =
      nums_str
      |> Enum.map(fn rows -> Enum.map(rows, &String.to_integer/1) end)
      |> Enum.zip()
      |> Enum.map(&Tuple.to_list/1)

    calc(ops, nums_rows)
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    data =
      input
      |> parse_lines()

    {ops_raw, nums_raw} = List.pop_at(data, -1)

    ops = Regex.scan(~r/\S+/, ops_raw) |> List.flatten()

    max_str_len =
      Enum.max_by(nums_raw, &String.length/1)
      |> String.length()

    nums_rows =
      nums_raw
      |> Enum.map(fn row ->
        String.pad_trailing(row, max_str_len, "0")
        |> String.to_charlist()
      end)
      |> Enum.zip()
      |> Enum.chunk_by(fn rows -> Tuple.to_list(rows) |> Enum.all?(&(&1 == 32)) end)
      |> Enum.reject(fn chunk -> length(chunk) == 1 end)
      |> Enum.map(fn chunk ->
        Enum.map(chunk, fn num_tuple ->
          Tuple.to_list(num_tuple)
          |> String.Chars.to_string()
          |> String.trim()
          |> String.to_integer()
        end)
      end)

    calc(ops, nums_rows)
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
