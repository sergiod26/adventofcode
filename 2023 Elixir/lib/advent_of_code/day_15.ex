defmodule AdventOfCode.Day15 do
  def part1(args) do
    String.trim(args)
    |> String.split(",", trim: true)
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  defp hash(str) do
    String.to_charlist(str) |> Enum.reduce(0, fn x, acc -> rem((acc + x) * 17, 256) end)
  end

  def part2(args) do
    String.trim(args)
    |> String.split(",", trim: true)
    |> Enum.reduce(%{}, fn step, acc ->
      hashmap(acc, String.split(step, ["=", "-"], trim: true))
    end)
    |> Enum.map(fn {box, slots} ->
      Enum.with_index(slots, 1)
      |> Enum.map(fn {{_, power}, ix} -> (box + 1) * ix * String.to_integer(power) end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  defp hashmap(map, [label]) do
    box = hash(label)

    if Map.has_key?(map, box) do
      Map.get_and_update(map, box, fn curr ->
        {curr, curr |> Enum.filter(fn {l, _} -> l != label end)}
      end)
      |> elem(1)
    else
      map
    end
  end

  defp hashmap(map, [label, num]) do
    box = hash(label)

    Map.update(map, box, [{label, num}], fn slots ->
      if Enum.count(slots, fn {l, _} -> l == label end) > 0 do
        slots |> Enum.map(fn {l, n} -> if l == label, do: {l, num}, else: {l, n} end)
      else
        slots ++ [{label, num}]
      end
    end)
  end
end
