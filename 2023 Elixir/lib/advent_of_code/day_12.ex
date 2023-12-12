defmodule AdventOfCode.Day12 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [springs, numbers] = String.split(l, " ", trim: true)
      springs = String.codepoints(springs)
      numbers = String.split(numbers, ",") |> Enum.map(&String.to_integer/1)

      {springs, numbers}

      combinations(springs, Enum.sum(numbers))
      |> Enum.filter(fn comb -> count_defects(List.to_string(comb)) == numbers end)
      |> length()
    end)
    |> Enum.sum()
  end

  defp combinations([head], _max) do
    if head == "?",
      do: [["."], ["#"]],
      else: [[head]]
  end

  defp combinations([head | tail], max) do
    rest = combinations(tail, max)

    if head == "?" do
      Enum.map(rest, fn sub -> ["." | sub] end) ++
        Enum.map(rest, fn sub -> ["#" | sub] end)
    else
      Enum.map(rest, fn sub -> [head | sub] end)
    end
  end

  defp count_defects(str) do
    Regex.scan(~r/(#+)/, str) |> Enum.map(fn [_, x] -> String.codepoints(x) |> length() end)
  end

  def part2(_args) do
  end
end
