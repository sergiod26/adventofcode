defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      Regex.scan(~r/(\d)/, l)|> Enum.map(fn [_, d] -> d end) end)
      |> Enum.map(fn x -> String.to_integer("#{Enum.take(x, 1)}#{Enum.take(x, -1)}") end)
      |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      Regex.scan(~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/, l)
        |> Enum.map(fn [_, c] ->
          case c do
            "one"-> 1
            "two"-> 2
            "three"-> 3
            "four"-> 4
            "five"-> 5
            "six"-> 6
            "seven"-> 7
            "eight"-> 8
            "nine"-> 9
            x -> String.to_integer(x)
          end
        end)
      end)
      |> Enum.map(fn x -> Enum.at(x, 0) * 10 + Enum.at(x, -1) end)
      |> Enum.sum()
  end
end
