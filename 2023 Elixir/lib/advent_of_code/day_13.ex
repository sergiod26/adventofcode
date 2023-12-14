defmodule AdventOfCode.Day13 do
  require Integer

  def part1(args) do
    abc =
      args
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn pattern ->
        String.split(pattern, "\n", trim: true)
      end)
      |> Enum.map(fn pattern ->
        rows = both_ways(pattern)

        transposed = transpose(Enum.map(pattern, &String.codepoints/1)) |> Enum.map(&Enum.join/1)
        cols = both_ways(transposed)

        [cols, rows]
      end)

    [c, r] = abc |> Enum.reduce([0, 0], fn [c, r], [tc, tr] -> [c + tc, r + tr] end)

    100 * r + c
  end

  defp both_ways(pattern) do
    len = length(pattern)
    reversed = Enum.reverse(pattern)

    a = solve(pattern, reversed)
    a_size = if a > 0, do: div(len - a, 2), else: 0
    a_final = if a > 0, do: a_size + a, else: 0

    rev = solve(reversed, pattern)
    rev_size = if rev > 0, do: div(len - rev, 2), else: 0
    rev_final = if rev > 0, do: rev_size, else: 0

    {_, res} = [{a_size, a_final}, {rev_size, rev_final}] |> Enum.max_by(fn {size, _} -> size end)

    res
  end

  defp solve(list, list_rev, ix \\ 0)
  defp solve([_], _, _ix), do: -1

  defp solve([_ | t1] = list1, list2, ix) do
    if Integer.is_even(length(list1)) && List.starts_with?(list2, list1),
      do: ix,
      else: solve(t1, list2, ix + 1)
  end

  def transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def part2(_args) do
  end
end
