defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.replace("X", "A")
    |> String.replace("Y", "B")
    |> String.replace("Z", "C")
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, " ", trim: true)
    end)
    |> Enum.map(fn [v1, v2] -> rule(v2, v1) + points(v2) end)
    |> Enum.sum()
  end

  defp rule("A", "C"), do: 6
  defp rule("B", "A"), do: 6
  defp rule("C", "B"), do: 6
  defp rule(z, z), do: 3
  defp rule(_, _), do: 0

  defp points("A"), do: 1
  defp points("B"), do: 2
  defp points("C"), do: 3

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, " ", trim: true)
    end)
    |> Enum.map(fn [v1, v2] -> newrule(v1, v2) end)
    |> Enum.sum()
    |> dbg
  end

  defp newrule(z, "X"), do: points(wins(z))
  defp newrule(z, "Y"), do: points(z) + 3
  defp newrule(z, "Z"), do: points(loss(z)) + 6

  defp loss("A"), do: "B"
  defp loss("B"), do: "C"
  defp loss("C"), do: "A"

  defp wins("A"), do: "C"
  defp wins("B"), do: "A"
  defp wins("C"), do: "B"
end
