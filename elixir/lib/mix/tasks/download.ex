defmodule Mix.Tasks.Download do
  @moduledoc "Download input from AoC using `mix download <year> <day>` (.env required)"
  @shortdoc "Download input"

  use Mix.Task

  @impl Mix.Task
  def run([year, day]) do
    Mix.Task.run("app.start") # required to invoke dotenv
    Aoc.Client.download_input(year, day)
  end
end
