defmodule AocTest.Y2025.D3 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D3, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  987654321111111
  811111111111119
  234234234234278
  818181911112111
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 357
    end

    test "part 2" do
      assert Solver.part2(@example) == 3_121_910_778_619
    end
  end
end
