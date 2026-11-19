defmodule Aoc.Y2025.D10 do
  import Aoc.Util

  @type choice :: [integer()]

  @spec trim_lr(String.t()) :: String.t()
  def trim_lr(str), do: String.slice(str, 1..-2//1)

  @spec parse_head(String.t()) :: [pos_integer()]
  def parse_head(elem) do
    trim_lr(elem)
    |> String.to_charlist()
    |> Enum.map(
      &case &1 do
        ?. -> 0
        ?# -> 1
      end
    )
  end

  @spec parse_nums(String.t()) :: [integer()]
  def parse_nums(elem) do
    trim_lr(elem)
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  @spec get_data(String.t()) :: [{[pos_integer()], [[integer()]], [integer()]}]
  def get_data(input) do
    parse_input(input)
    |> Enum.map(fn row ->
      [head | tail] = String.split(row, " ")
      {last, body} = List.pop_at(tail, -1)
      {parse_head(head), Enum.map(body, &parse_nums/1), parse_nums(last)}
    end)
  end

  @spec update_state([integer()], choice()) :: [integer()]
  def update_state(state, choice) do
    Enum.reduce(choice, state, fn idx, acc ->
      List.update_at(acc, idx, &Integer.mod(&1 + 1, 2))
    end)
  end

  @spec find_least_combinations([{[integer()], [choice()], [choice()]}], [integer()]) ::
          pos_integer()
  def find_least_combinations(states, target) do
    new_states =
      Enum.flat_map(states, fn {state, selected, remained} ->
        for {choice, idx} <- Enum.with_index(remained) do
          {_, rem_choices} = List.pop_at(remained, idx)

          {
            update_state(state, choice),
            selected ++ [choice],
            rem_choices
          }
        end
      end)

    if Enum.any?(new_states, fn {state, _selected, _remained} ->
         state == target
       end),
       do: hd(new_states) |> elem(1) |> length,
       else:
         find_least_combinations(
           new_states,
           target
         )
  end

  @spec part1(String.t()) :: any()
  def part1(input) do
    get_data(input)
    |> Enum.sum_by(fn {target, buttons, _} ->
      find_least_combinations(
        [{List.duplicate(0, length(target)), [], buttons}],
        target
      )
    end)
  end

  @type row :: [integer()]

  @spec build_matrix([integer()], [choice()]) :: [row()]
  def build_matrix(target, buttons) do
    target
    |> Enum.with_index()
    |> Enum.map(fn {target_elem, target_idx} ->
      Enum.map(buttons, fn button -> if target_idx in button, do: 1, else: 0 end) ++ [target_elem]
    end)
  end

  @spec eliminate(row(), row(), pos_integer()) :: row()
  defp eliminate(target_row, pivot_row, col_idx) do
    target_coef = Enum.at(target_row, col_idx)

    # if target row -> cell is 0; doesn't suppose to apply reduction
    if target_coef == 0 do
      target_row
    else
      pivot_coef = Enum.at(pivot_row, col_idx)

      Enum.zip_with(target_row, pivot_row, fn target_val, pivot_val ->
        target_val * pivot_coef - pivot_val * target_coef
      end)
      |> shrink()
    end
  end

  # divide the row by its gcd so numbers stay small
  @spec shrink(row()) :: row()
  defp shrink(row) do
    gcd = Enum.reduce(row, 0, &Integer.gcd/2)
    if gcd == 0, do: row, else: Enum.map(row, &div(&1, gcd))
  end

  @type pivot :: {pos_integer(), row()}

  @doc "Reduced Row Echelon Form"
  @spec rref([row()], integer()) :: [pivot()]
  def rref(matrix, choice_count) do
    # iterate through each column
    # accumulator = { pivots, matrix }
    # pivots = { column_idx, owned_row }
    Enum.reduce(0..(choice_count - 1), {[], matrix}, fn col_idx, {pivots, acc_mat} ->
      # find a column owned by which row (target) -> {true, false}
      case Enum.split_with(acc_mat, fn row_idx -> Enum.at(row_idx, col_idx) == 0 end) do
        # no row can own this button = free button
        {_, []} ->
          {pivots, acc_mat}

        # found row that can own column, reduce others (previous pivots, other rows)
        {zero_rows, [pivot_row | other_rows]} ->
          new_pivots =
            [
              {col_idx, pivot_row}
              | Enum.map(pivots, fn {prev_col_idx, prev_row} ->
                  {prev_col_idx, eliminate(prev_row, pivot_row, col_idx)}
                end)
            ]

          {new_pivots, zero_rows ++ Enum.map(other_rows, &eliminate(&1, pivot_row, col_idx))}
      end
    end)
    |> elem(0)
  end

  @type assigned_val :: {pos_integer(), integer()}

  @spec calculate([assigned_val()], [pivot()]) :: {:ok, [pos_integer()]} | :error
  def calculate(assigned, pivots) do
    Enum.reduce_while(pivots, {:ok, []}, fn {pivot_col, owned_row}, {:ok, acc} ->
      pivot_cell_val = Enum.at(owned_row, pivot_col)
      rhs = List.last(owned_row)

      sum_assigned =
        for {col, val} <- assigned do
          Enum.at(owned_row, col) * val
        end
        |> Enum.sum()

      diff = rhs - sum_assigned

      quotient = div(diff, pivot_cell_val)
      remainder = rem(diff, pivot_cell_val)

      # button press must be pos_int
      if quotient >= 0 and remainder == 0 do
        # now we know how much we need to press each owned button
        {:cont, {:ok, [quotient | acc]}}
      else
        # not whole, or negative -> not allowed
        {:halt, :error}
      end
    end)
  end

  @spec cartesian([[any()]]) :: [[any()]]
  def cartesian([]), do: []
  def cartesian([list | []]), do: Enum.map(list, &[&1])

  def cartesian([hd_list | tl_lists]) do
    for elem <- hd_list, tail <- cartesian(tl_lists), do: [elem | tail]
  end

  @spec search([list(assigned_val())], [pivot()]) :: integer()
  def search([], pivots) do
    calculate([], pivots)
    # will cause error immediately
    |> elem(1)
    |> Enum.sum()
  end

  def search(free_vals, pivots) do
    free_vals
    |> Enum.map(fn assign_vals ->
      case calculate(assign_vals, pivots) do
        {:ok, vals} ->
          Enum.sum(vals) +
            (Enum.map(assign_vals, &elem(&1, 1))
             |> Enum.sum())

        :error ->
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Enum.min()
  end

  @doc "Gaussian elimination"
  @spec solve([integer()], [choice()]) :: integer()
  def solve(target, buttons) do
    btn_count = length(buttons)

    pivots =
      build_matrix(target, buttons)
      |> rref(btn_count)

    pivot_cols = Enum.map(pivots, &elem(&1, 0))
    pivot_set = MapSet.new(pivot_cols)

    # find min value of free button to searchs
    free_val_max_val =
      for {row, btn_idx} <- Enum.with_index(buttons), btn_idx not in pivot_set do
        {btn_idx, Enum.map(row, &Enum.at(target, &1)) |> Enum.min()}
      end

    free_val_tuples =
      Enum.map(free_val_max_val, fn {free_val_col, max_val} ->
        for v <- 0..max_val, do: {free_val_col, v}
      end)
      |> cartesian()

    search(free_val_tuples, pivots)
  end

  @spec part2(String.t()) :: any()
  def part2(input) do
    get_data(input)
    |> Enum.sum_by(fn {_, buttons, target} ->
      solve(target, buttons)
    end)
  end

  @spec parse_input(String.t()) :: list(String.t())
  def parse_input(input) do
    parse_lines(input)
    |> Enum.map(&String.trim/1)
  end
end
