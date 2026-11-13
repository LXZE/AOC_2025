defmodule AocTest.Y2025.D9 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D9, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  7,1
  11,1
  11,7
  9,7
  9,5
  2,5
  2,3
  7,3
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 50
    end

    test "part 2" do
      assert Solver.part2(@example) == 24
    end
  end
end
