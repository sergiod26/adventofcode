defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      Regex.replace(~r/Game \d+\:/, l, "") |> String.split(";") |> Enum.map(
        fn subset->
          String.split(subset, ",", trim: true) |> Enum.map(fn pair ->
            [q, color] = String.split(pair, " ", trim: true)
            possible(color, String.to_integer(q))
          end)
        end)
        |> List.flatten()
        |> Enum.all?(fn x -> x end)
    end)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {possible, ix}, acc -> if possible do acc + ix + 1 else acc end end)
  end

  defp possible("red", x), do: x <= 12
  defp possible("green", x), do: x <= 13
  defp possible("blue", x), do: x <= 14

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      Regex.replace(~r/Game \d+\:/, l, "") |> String.split(";") |> Enum.map(
        fn subset->
          String.split(subset, ",", trim: true)
          |> Enum.map(fn pair ->
            [q, color] = String.split(pair, " ", trim: true)
            [color, String.to_integer(q)]
          end)
        end)
        |> Enum.concat()
        |> Enum.reduce(%{"red"=> 0, "blue"=> 0, "green"=> 0}, fn [color, num], acc ->
          if acc[color] < num do Map.put(acc, color, num) else acc end end)
          |> dbg()
    end)
    |> Enum.reduce(0, fn %{"red"=> r, "blue"=> b, "green"=> g}, acc -> acc + (r * b * g) end)
  end
end
