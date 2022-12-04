# Reasoning: just ranges...
# 1. check if one is subset of the other
# 2. check if they intersect

defmodule AdventOfCode.Day04 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, ",")
      |> Enum.map(fn x ->
        String.split(x, "-")
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(fn [a, b] -> MapSet.new(a..b) end)
    end)
  end

  def part1(args) do
    args
    |> parse
    |> Enum.filter(fn [s1, s2] -> MapSet.subset?(s1, s2) || MapSet.subset?(s2, s1) end)
    |> length
  end

  def part2(args) do
    args
    |> parse
    |> Enum.filter(fn [s1, s2] -> MapSet.intersection(s1, s2) |> MapSet.size() > 0 end)
    |> length()
  end
end
