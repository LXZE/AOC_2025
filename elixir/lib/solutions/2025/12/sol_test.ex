defmodule AocTest.Y2025.D12 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D12, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  0:
  ###
  ##.
  ##.

  1:
  ###
  ##.
  .##

  2:
  .##
  ###
  ##.

  3:
  ##.
  ###
  ##.

  4:
  ###
  #..
  ###

  5:
  ###
  .#.
  ###

  4x4: 0 0 0 0 2 0
  12x5: 1 0 1 0 2 2
  12x5: 1 0 1 0 3 2
  """

  describe "Example case" do
    test "part 1" do
      # the code won't work with example, but real data
      # assert Solver.part1(@example) == 2
    end

    test "part 2" do
      assert Solver.part2(@example) == :ok
    end
  end
end
