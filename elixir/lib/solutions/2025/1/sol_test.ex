defmodule AocTest.Y2025.D1 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D1, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  L68
  L30
  R48
  L5
  R60
  L55
  L1
  L99
  R14
  L82
  """

  @example2 ~S"""
  R1000
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 3
    end

    test "part 2" do
      assert Solver.part2(@example) == 6
      assert Solver.part2(@example2) == 10
    end
  end
end
