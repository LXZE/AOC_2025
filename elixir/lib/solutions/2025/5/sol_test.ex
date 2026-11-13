defmodule AocTest.Y2025.D5 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D5, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  3-5
  10-14
  16-20
  12-18

  1
  5
  8
  11
  17
  32
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 3
    end

    test "part 2" do
      assert Solver.part2(@example) == 14
    end
  end
end
