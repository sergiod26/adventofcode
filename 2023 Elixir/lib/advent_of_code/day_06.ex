defmodule AdventOfCode.Day06 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l) |> Enum.drop(1) |> Enum.map(&String.to_integer/1) end)
    |> Enum.zip()
    |> Enum.map(fn {time, distance} ->
      length(1..time |> Enum.filter(fn x -> (time - x) * x > distance end))
    end)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2(args) do
    [time, distance] =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn l ->
        String.split(l) |> Enum.drop(1) |> Enum.join() |> String.to_integer()
      end)

    length(1..time |> Enum.filter(fn x -> (time - x) * x > distance end))
  end
end
