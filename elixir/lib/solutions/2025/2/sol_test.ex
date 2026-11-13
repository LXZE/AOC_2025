defmodule AocTest.Y2025.D2 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D2, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 1_227_775_554
    end

    test "part 2" do
      assert Solver.part2(@example) == 4_174_379_265
    end
  end
end
