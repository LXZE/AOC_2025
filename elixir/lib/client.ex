defmodule Aoc.Client do
  @moduledoc "Client module to download input given day and year from aoc, required session cookie"

  @spec download_input(String.t(), String.t()) :: any()
  def download_input(year, day) do
    create_input_dir(year, day)
    |> write_input(year, day)

    IO.puts("Successfully download input day #{day}/#{year} to input/#{year}/#{day}")
  end

  @spec create_input_dir(String.t(), String.t()) :: String.t()
  def create_input_dir(year, day) do
    target_directory = "input/#{year}/#{day}"
    Mix.Generator.create_directory(target_directory)
    target_directory
  end

  defp get_cookie, do: Dotenv.get("AOC_COOKIE")

  @spec fetch_input(String.t(), String.t()) :: binary()
  def fetch_input(year, day) do
    Req.get!("https://adventofcode.com/#{year}/day/#{day}/input",
      headers: [
        {"Cookie", "session=#{get_cookie()}"}
      ]
    ).body
  end

  @spec write_input(String.t(), String.t(), String.t()) :: :ok | {:error, atom()}
  def write_input(target_directory, year, day) do
    file_name = "#{target_directory}/input.txt"
    File.write(file_name, fetch_input(year, day))
  end

end
