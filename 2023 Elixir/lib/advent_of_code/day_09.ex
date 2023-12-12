defmodule AdventOfCode.Day09 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn line ->
      Enum.reduce_while(
        Stream.iterate(1, &(&1 + 1)),
        {line, Enum.take(line, -1)},
        fn _, {current, list} ->
          if Enum.all?(current, fn x -> x == 0 end) do
            {:halt, list}
          else
            next = diffs(current)
            {:cont, {next, [Enum.at(next, -1) | list]}}
          end
        end
      )
      |> Enum.sum()
    end)
    |> Enum.sum()
  end

  defp diffs([s, f]), do: [f - s]
  defp diffs([f, s | tail]), do: [s - f | diffs([s | tail])]

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn line ->
      Enum.reduce_while(
        Stream.iterate(1, &(&1 + 1)),
        {line, Enum.take(line, 1)},
        fn _, {current, list} ->
          if Enum.all?(current, fn x -> x == 0 end) do
            {:halt, list}
          else
            next = diffs(current)
            {:cont, {next, [Enum.at(next, 0) | list]}}
          end
        end
      )
      |> Enum.reduce(fn x, acc -> x - acc end)
    end)
    |> Enum.sum()
  end
end
