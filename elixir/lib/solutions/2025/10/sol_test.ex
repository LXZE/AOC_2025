defmodule AocTest.Y2025.D10 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D10, as: Solver
  setup do: IO.puts("\n")
  @example ~S"""
  [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
  [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
  [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 7
    end

    test "part 2" do
      assert Solver.part2(@example) == 33
    end
  end
end
