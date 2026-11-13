defmodule Mix.Tasks.Aoc.Run do
  @moduledoc """
    Run solution with actual input

    ## Examples
      - `mix aoc.run <file_path>`
  """
  @shortdoc "Run Aoc solution using actual input (input file must be loaded)"

  use Mix.Task

  @impl Mix.Task
  def run([target_dir]) do
    [day, year | _] = String.split(target_dir, "/") |> Enum.reverse
    run([year, day])
  end

  @impl Mix.Task
  def run([year, day]) do
    input_path = "/input/#{year}/#{day}/input.txt"
    input = File.read!(File.cwd!() <> input_path)
    module = "Elixir.Aoc.Y#{year}.D#{day}" |> String.to_existing_atom()

    res_part1 = apply(module, :part1, [input])
    if res_part1 != :ok, \
      do: IO.puts("part1: #{res_part1}"), \
      else: IO.puts("part1: unfinished")
    IO.puts("")

    res_part2 = apply(module, :part2, [input])
    if res_part2 != :ok, \
      do: IO.puts("part2: #{res_part2}"), \
      else: IO.puts("part2: unfinished")
    IO.puts("")
  end
end
