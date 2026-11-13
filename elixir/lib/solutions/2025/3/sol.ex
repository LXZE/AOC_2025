defmodule Aoc.Y2025.D3 do
  import Aoc.Util

  @spec get_biggest_substr(String.t(), pos_integer()) :: integer() | none()
  @spec get_biggest_substr(String.t(), pos_integer(), list(integer())) :: integer() | none()
  def get_biggest_substr(_, _, acc \\ [])

  def get_biggest_substr(_, max_size, acc) when length(acc) == max_size do
    acc
    |> Enum.map(&(&1 + ?0))
    |> List.to_string()
    |> String.to_integer()
  end

  def get_biggest_substr("", _, _), do: nil

  def get_biggest_substr(
        data,
        max_size,
        acc
      ) do
    9..1//-1
    |> Enum.find_value(fn num ->
      substrs = String.split(data, "#{num}", parts: 2)

      if length(substrs) == 2 do
        get_biggest_substr(
          Enum.at(substrs, 1),
          max_size,
          acc ++ [num]
        )
      end
    end)
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    parse_input(input)
    |> Enum.map(&get_biggest_substr(&1, 2))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    parse_input(input)
    |> Enum.map(&get_biggest_substr(&1, 12))
    |> Enum.sum()
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
