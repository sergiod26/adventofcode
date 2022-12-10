defmodule AdventOfCode.Day10 do
  def part1(args) do
    cycles = cycles(args)

    [20, 60, 100, 140, 180, 220]
    |> Enum.map(fn pos ->
      {_, x} = Enum.at(cycles, pos - 1)
      x * pos
    end)
    |> Enum.sum()
  end

  # noop takes 1, addx takes 2... crating tuples like {num_of_cycles, register_increase}
  defp cycles(args) do
    args
    |> String.split("\n", trim: true)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn
      ["addx", v] -> {2, String.to_integer(v)}
      ["noop"] -> {1, 0}
    end)
    |> Enum.reduce([{1, 1}], fn {op, v}, [{x, y} | _] = acc ->
      next_register = x + op

      # For part one wasn't doing this... but having them all makes part 2 easier
      pad =
        if(next_register > x + 1,
          do:
            (x + 1)..(next_register - 1)
            |> Enum.map(&{&1, y}),
          else: []
        )

      [{x + op, y + v} | pad] ++ acc
    end)
    |> Enum.reverse()
  end

  def part2(args) do
    cycles(args)
    |> Enum.map(fn {x, y} ->
      xx = Integer.mod(x - 1, 40)
      if(xx == y || xx == y - 1 || xx == y + 1, do: "#", else: ".")
    end)
    |> Enum.chunk_every(40)
    |> Enum.join("~")
  end
end
