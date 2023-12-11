defmodule AdventOfCode.Day11 do
  def part1(args), do: solve(args, 1)
  def part2(args), do: solve(args, 1_000_000 - 1)

  defp solve(args, factor) do
    matrix = args |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)

    map =
      for {row, row_ix} <- Enum.with_index(matrix) do
        for({val, col_ix} <- Enum.with_index(row)) do
          {val, row_ix, col_ix}
        end
      end
      |> List.flatten()
      |> Enum.reduce([], fn {val, row, col}, acc ->
        if val == "#",
          do: [{row, col} | acc],
          else: acc
      end)

    {row_size, _} = map |> Enum.max_by(fn {x, _} -> x end)
    {_, col_size} = map |> Enum.max_by(fn {_, x} -> x end)

    empty_rows =
      Enum.filter(0..row_size, fn r ->
        r not in Enum.map(map, fn {x, _} -> x end)
      end)

    empty_cols =
      Enum.filter(0..col_size, fn c ->
        c not in Enum.map(map, fn {_, x} -> x end)
      end)

    map =
      map
      |> Enum.map(fn {r, c} ->
        Enum.reduce(empty_rows, {{r, c}, r}, fn row, {{rx, cx}, initial} = acc ->
          if initial > row, do: {{rx + factor, cx}, initial}, else: acc
        end)
      end)
      |> Enum.map(fn {{r, c}, _} ->
        Enum.reduce(empty_cols, {{r, c}, c}, fn col, {{rx, cx}, initial} = acc ->
          if initial > col, do: {{rx, cx + factor}, initial}, else: acc
        end)
      end)
      |> Enum.map(fn {x, _} -> x end)

    combinations(map) |> Enum.map(&manhattan/1) |> Enum.sum()
  end

  defp combinations([_]), do: []
  defp combinations([h | t]), do: Enum.map(t, fn x -> {h, x} end) ++ combinations(t)

  defp manhattan({{x1, y1}, {x2, y2}}) do
    abs(x1 - x2) + abs(y1 - y2)
  end
end
