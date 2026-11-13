defmodule Mix.Tasks.Aoc.Test do
  @moduledoc """
    Run solution with test case

    ## Examples
      - `mix aoc.test <file_path>`
  """
  @shortdoc "Test Aoc solution using test case"

  use Mix.Task

  @impl Mix.Task
  def run([target_dir]) do
    [day, year | _] = String.split(target_dir, "/") |> Enum.reverse
    run([year, day])
  end

  @impl Mix.Task
  def run([year, day]) do
    module = "Elixir.AocTest.Y#{year}.D#{day}" |> String.to_existing_atom()
    ExUnit.start(seed: 0)
    ExUnit.run([module])
  end
end
