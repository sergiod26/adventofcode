defmodule AdventOfCode.Day04 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [winning, owned] =
        Regex.replace(~r/Card \d+\: /, l, "")
        |> String.split("|")
        |> Enum.map(fn card -> String.split(card, " ", trim: true) end)

      length(winning -- winning -- owned) - 1
    end)
    |> Enum.filter(fn x -> x >= 0 end)
    |> Enum.reduce(0, fn x, acc -> :math.pow(2, x) + acc end)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [winning, owned] =
        Regex.replace(~r/Card \d+\: /, l, "")
        |> String.split("|")
        |> Enum.map(fn card -> String.split(card, " ", trim: true) end)

      length(winning -- winning -- owned)
    end)
    |> Enum.reduce({0, []}, fn n, {total, acc} ->
      multipliers = length(acc) + 1

      {total + multipliers,
       (List.duplicate(n, multipliers) ++
          (acc
           |> Enum.map(fn x -> x - 1 end)))
       |> Enum.filter(fn q -> q > 0 end)}
    end)
    |> elem(0)
  end
end
