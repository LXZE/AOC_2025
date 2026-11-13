defmodule AocTest.Y2025.D6 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D6, as: Solver
  setup do: IO.puts("\n")

  @example ~S(
123 328  51 64
 45 64  387 23
  6 98  215 314
*   +   *   +
)

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 4277556
    end

    test "part 2" do
      assert Solver.part2(@example) == 3263827
    end
  end
end
