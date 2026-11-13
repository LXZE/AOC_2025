defmodule Mix.Tasks.Gen do
  @moduledoc """
    Generate solution and test file by year and day from template.

    ## Examples
      - `mix gen 2020 1` -> Create sol.ex and sol_test.ex files in directory lib/solutions/2020/1/

    ## Options
      `-dl | --download` - download input from AoC website to /input/<year>/<day>/input.txt
      Note. require .env and session cookie
  """
  @shortdoc "Generate solution file from template"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    Mix.Task.run("app.start")

    {argv, [year, day], _} = OptionParser.parse(args,
      aliases: [dl: :download],
      strict: [download: :boolean]
    )
    IO.puts("Generate template for solving AOC day #{day}/#{year}")

    target_directory = "lib/solutions/#{year}/#{day}"
    Mix.Generator.create_directory(target_directory)

    template_param = [year: year, day: day]
    Mix.Generator.copy_template("template/sol.ex.eex", "#{target_directory}/sol.ex", template_param)
    Mix.Generator.copy_template("template/sol_test.ex.eex", "#{target_directory}/sol_test.ex", template_param)

    download? = Keyword.get(argv, :download, false)
    if download?, do: Aoc.Client.download_input(year, day)

    IO.puts("Successfully generate solution template #{day}/#{year} in lib/solutions/#{year}/#{day}")
  end
end
