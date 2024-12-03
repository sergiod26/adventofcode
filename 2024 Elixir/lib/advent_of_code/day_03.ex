defmodule AdventOfCode.Day03 do
  def part1(args) do
    Regex.scan(~r/mul\((\d[\d]?[\d]?),(\d[\d]?[\d]?)\)/, args)
    |> Enum.reduce(0, fn [_, a, b], acc -> acc + String.to_integer(a) * String.to_integer(b) end)
  end

  def part2(args) do
    Regex.scan(~r/do\(\)|don't\(\)|mul\((\d[\d]?[\d]?),(\d[\d]?[\d]?)\)/, args)
    |> Enum.reduce({true, 0}, fn match, {x, acc} ->
      case match do
        [_, a, b] ->
          case x do
            true -> {x, acc + String.to_integer(a) * String.to_integer(b)}
            false -> {x, acc}
          end

        ["do()"] ->
          {true, acc}

        ["don't()"] ->
          {false, acc}
      end
    end)
    |> elem(1)
  end
end
