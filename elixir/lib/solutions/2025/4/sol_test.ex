defmodule AocTest.Y2025.D4 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D4, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  ..@@.@@@@.
  @@@.@.@.@@
  @@@@@.@.@@
  @.@@@@..@.
  @@.@@@@.@@
  .@@@@@@@.@
  .@.@.@.@@@
  @.@@@.@@@@
  .@@@@@@@@.
  @.@.@@@.@.
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 13
    end

    test "part 2" do
      assert Solver.part2(@example) == 43
    end
  end
end
