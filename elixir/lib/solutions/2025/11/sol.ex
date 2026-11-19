defmodule Aoc.Y2025.D11 do
  import Aoc.Util

  @type graph :: %{String.t() => MapSet.t(String.t())}

  @spec get_graph(String.t()) :: graph()
  def get_graph(input) do
    parse_input(input)
    |> Enum.map(fn row ->
      [hd, tail] = String.split(row, ": ")
      {hd, MapSet.new(String.split(tail, " "))}
    end)
    |> Map.new()
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    graph = get_graph(input)

    Stream.repeatedly(fn -> nil end)
    |> Enum.reduce_while({0, ["you"]}, fn _, {acc, state} ->
      {leafs, new_state} =
        Enum.map(state, &graph[&1])
        |> Enum.split_with(&(&1 == MapSet.new(["out"])))

      new_acc = acc + length(leafs)

      if length(new_state) == 0 do
        {:halt, new_acc}
      else
        {:cont, {new_acc, new_state |> Enum.flat_map(&MapSet.to_list/1)}}
      end
    end)
  end

  @type cache_key :: {String.t(), MapSet.t(String.t())}
  @type cache :: %{cache_key() => pos_integer()}

  @spec traverse(String.t(), MapSet.t(String.t()), cache(), {graph(), MapSet.t(String.t())}) :: {integer(), cache()}
  def traverse("out", state, cache, _const) do
    # return {1, cache} or {0, cache};
    # elem(0) will be 1 only if "out" state already reached targets ("fft", "dac") == #2
    {div(MapSet.size(state), 2), cache}
  end

  def traverse(current_node, state, cache, {graph, target_set} = const) do
    cache_key = {current_node, state}

    case cache do
      %{^cache_key => value} ->
        {value, cache}

      _ ->
        {counts, cache} =
          graph[current_node]
          |> Enum.map_reduce(cache, fn next_node, acc_cache ->
            new_state =
              if next_node in target_set do
                MapSet.put(state, next_node)
              else
                state
              end

            traverse(next_node, new_state, acc_cache, const)
          end)

        total = Enum.sum(counts)
        {total, Map.put(cache, cache_key, total)}
    end
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    graph = get_graph(input)

    traverse("svr", MapSet.new(), Map.new(), {graph, MapSet.new(["fft", "dac"])})
    |> elem(0)
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
