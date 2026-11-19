defmodule AocTest.Y2025.D11 do
  use ExUnit.Case, async: false

  alias Aoc.Y2025.D11, as: Solver
  setup do: IO.puts("\n")

  @example ~S"""
  aaa: you hhh
  you: bbb ccc
  bbb: ddd eee
  ccc: ddd eee fff
  ddd: ggg
  eee: out
  fff: out
  ggg: out
  hhh: ccc fff iii
  iii: out
  """

  @example2 ~S"""
  svr: aaa bbb
  aaa: fft
  fft: ccc
  bbb: tty
  tty: ccc
  ccc: ddd eee
  ddd: hub
  hub: fff
  eee: dac
  dac: fff
  fff: ggg hhh
  ggg: out
  hhh: out
  """

  describe "Example case" do
    test "part 1" do
      assert Solver.part1(@example) == 5
    end

    test "part 2" do
      assert Solver.part2(@example2) == 2
    end
  end
end
