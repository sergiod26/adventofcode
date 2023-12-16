defmodule AdventOfCode.Day12 do
  # Credits to https://elixirforum.com/t/advent-of-code-2023-day-12/60309

  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, damaged] = String.split(line, " ", trim: true)
      damaged = String.split(damaged, ",", trim: true) |> Enum.map(&String.to_integer/1)

      step(springs, damaged)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [springs, damaged] = String.split(line, " ", trim: true)

      springs = List.duplicate(springs, 5) |> Enum.join("?")

      damaged =
        String.split(damaged, ",", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.duplicate(5)
        |> List.flatten()

      step(springs, damaged)
    end)
    |> Enum.sum()
  end

  defp step(springs, damaged, prev \\ "")

  defp step("", [0], _), do: 1
  defp step("", [], _), do: 1
  defp step("", _, _), do: 0

  defp step("#" <> _, [], _), do: 0
  defp step("#" <> _, [0 | _], _), do: 0
  defp step("#" <> rest, [d | tail], _), do: step(rest, [d - 1 | tail], "#")

  defp step("." <> rest, [0 | tail], "#"), do: step(rest, tail, ".")
  defp step("." <> _, [_ | _], "#"), do: 0
  defp step("." <> rest, damaged, _), do: step(rest, damaged, ".")

  defp step("?" <> rest, damaged, prev),
    do:
      with_cache({prev, "?" <> rest, damaged}, fn ->
        step("." <> rest, damaged, prev) + step("#" <> rest, damaged, prev)
      end)

  defp with_cache(key, fun) do
    with nil <- Process.get(key) do
      fun.() |> tap(&Process.put(key, &1))
    end
  end
end
