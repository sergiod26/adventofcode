defmodule AdventOfCode.Day09 do
  def part1(args) do
    solve(args)
  end

  def part2(args) do
    solve(args, 1)
  end

  defp diffs([s, f]), do: [f - s]
  defp diffs([f, s | tail]), do: [s - f | diffs([s | tail])]

  defp solve(args, pos \\ -1) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l -> String.split(l, " ") |> Enum.map(&String.to_integer/1) end)
    |> Enum.map(fn line ->
      Enum.reduce_while(
        Stream.iterate(1, &(&1 + 1)),
        {line, Enum.take(line, pos)},
        fn _, {current, list} ->
          if Enum.all?(current, fn x -> x == 0 end) do
            {:halt, list}
          else
            next = diffs(current)
            [val] = Enum.take(next, pos)
            {:cont, {next, [val | list]}}
          end
        end
      )
      |> Enum.reduce(fn x, acc -> x - pos * acc end)
    end)
    |> Enum.sum()
  end
end
