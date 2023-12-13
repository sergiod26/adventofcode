defmodule AdventOfCode.Day12 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [springs, numbers] = String.split(l, " ", trim: true)
      springs = String.codepoints(springs)
      numbers = String.split(numbers, ",") |> Enum.map(&String.to_integer/1) |> Enum.reverse()
      max = Enum.sum(numbers) - Enum.count(springs, fn x -> x == "#" end)

      combinations(springs, [{max, [0]}], numbers)
      |> Enum.filter(fn {x, abc} ->
        x == 0 && Enum.filter(abc, &(&1 != 0)) == numbers
      end)
      |> length()
    end)
    |> Enum.sum()
  end

  defp combinations([], acc, _), do: acc

  defp combinations([head | tail], acc, numbers) do
    tmp =
      case head do
        "?" ->
          acc
          |> Enum.flat_map(fn {count, [track | rest]} ->
            [{count, [0, track | rest]}, {count - 1, [track + 1 | rest]}]
          end)

        "#" ->
          Enum.map(acc, fn {count, [track | rest]} -> {count, [track + 1 | rest]} end)

        _ ->
          Enum.map(acc, fn {count, tracks} -> {count, [0 | tracks]} end)
      end
      |> Enum.filter(fn {count, tracks} ->
        tmp = Enum.filter(tracks, fn x -> x != 0 end)

        count >= 0 &&
          (length(tmp) == 0 ||
             (length(tmp) <= length(numbers) && Enum.max(tmp) <= Enum.max(numbers)))
      end)

    combinations(tail, tmp, numbers)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.take(1)
    |> Enum.map(fn l ->
      [springs, numbers] = String.split(l, " ", trim: true)
      springs = List.duplicate(springs, 5) |> Enum.join("?") |> String.codepoints()

      numbers =
        String.split(numbers, ",")
        |> Enum.map(&String.to_integer/1)
        |> List.duplicate(5)
        |> List.flatten()
        |> Enum.reverse()

      max = Enum.sum(numbers) - Enum.count(springs, fn x -> x == "#" end)

      combinations(springs, [{max, [0]}], numbers)
      |> Enum.filter(fn {x, abc} ->
        x == 0 && Enum.filter(abc, &(&1 != 0)) == numbers
      end)
      |> length()
    end)
    |> Enum.sum()
  end
end
