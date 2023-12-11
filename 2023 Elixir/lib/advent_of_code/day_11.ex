defmodule AdventOfCode.Day11 do
  def part1(args), do: solve(args, 1)
  def part2(args, factor \\ 1_000_000), do: solve(args, factor - 1)

  defp solve(args, factor) do
    matrix = args |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)

    # Get coordinates just for "#", map is a list of {row, col}
    map =
      for {row, row_ix} <- Enum.with_index(matrix) do
        for({val, col_ix} <- Enum.with_index(row)) do
          {val, row_ix, col_ix}
        end
      end
      |> List.flatten()
      |> Enum.filter(fn {val, _, _} -> val == "#" end)
      |> Enum.map(fn {_, row, col} -> {row, col} end)

    {{min_row, _}, {max_row, _}} = map |> Enum.min_max_by(fn {x, _} -> x end)
    {{_, min_col}, {_, max_col}} = map |> Enum.min_max_by(fn {_, x} -> x end)

    empty_rows =
      Enum.filter(min_row..max_row, fn r -> r not in Enum.map(map, fn {x, _} -> x end) end)

    empty_cols =
      Enum.filter(min_col..max_col, fn c -> c not in Enum.map(map, fn {_, x} -> x end) end)

    Enum.map(map, fn {r, c} ->
      # Using "initial" to remember original value, since all the extra lines are added "simultaneously"
      {row, _} =
        Enum.reduce_while(empty_rows, {r, r}, fn row, {rx, initial} = acc ->
          if initial > row, do: {:cont, {rx + factor, initial}}, else: {:halt, acc}
        end)

      {col, _} =
        Enum.reduce_while(empty_cols, {c, c}, fn col, {cx, initial} = acc ->
          if initial > col, do: {:cont, {cx + factor, initial}}, else: {:halt, acc}
        end)

      {row, col}
    end)
    |> combinations()
    |> Enum.map(&manhattan/1)
    |> Enum.sum()
  end

  defp combinations([_]), do: []
  defp combinations([h | t]), do: Enum.map(t, fn x -> {h, x} end) ++ combinations(t)

  defp manhattan({{x1, y1}, {x2, y2}}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
