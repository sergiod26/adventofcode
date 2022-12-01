defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.max()
  end

  def part2(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, "\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
