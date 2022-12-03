defmodule AdventOfCode.Day03 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      list = String.to_charlist(x)
      [c1, c2] = Enum.chunk_every(list, div(length(list), 2))

      # should I google for a real `intersect` yeah... does this work instead?! I think so
      tmp = c1 -- c2
      (c1 -- tmp) |> Enum.uniq() |> to_string
    end)
    |> Enum.map(fn x ->
      <<v::utf8>> = x
      if(v < 97, do: v - 38, else: v - 96)
    end)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] ->
      x1 = a -- b
      x2 = a -- x1
      x3 = x2 -- c
      (x2 -- x3) |> Enum.uniq() |> to_string
    end)
    |> Enum.map(fn x ->
      <<v::utf8>> = x
      if(v < 97, do: v - 38, else: v - 96)
    end)
    |> Enum.sum()
  end
end
