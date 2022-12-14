# Stuck in part1 for a while because I assumed there were rocks
# from the smallest x to the highest one (like in the example)

defmodule AdventOfCode.Day14 do
  def part1(args) do
    {cave, min_x, max_x, max_y} = parse(args)
    simulate(cave, min_x, max_x, max_y)
  end

  def part2(args) do
    {cave, min_x, max_x, max_y} = parse(args)
    simulate(cave, min_x, max_x, max_y + 1, true)
  end

  # Returns a list of coordinates with all rock spaces
  # %{{494, 9} => "#",{495, 9} => "#",{496, 6} => "#",...}
  defp parse(args) do
    cave =
      args
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn l ->
        String.split(l, " -> ", trim: true)
        |> Enum.map(fn coord ->
          String.split(coord, ",")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple()
        end)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.flat_map(fn
          [{x, y1}, {x, y2}] -> y1..y2 |> Enum.map(&{x, &1})
          [{x1, y}, {x2, y}] -> x1..x2 |> Enum.map(&{&1, y})
        end)
      end)
      |> Map.new(&{&1, "#"})

    {{min_x, _}, {max_x, _}} = Map.keys(cave) |> Enum.min_max_by(fn {x, _} -> x end)
    {_, max_y} = Map.keys(cave) |> Enum.max_by(fn {_, y} -> y end)

    {cave, min_x, max_x, max_y}
  end

  @start {500, 0}

  defp simulate(cave, min_x, max_x, max_y, infinite_floor \\ false) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(cave, fn _, acc ->
      {next, new_sand} = fall(acc, @start, {min_x, max_x}, max_y, infinite_floor)

      case next do
        :cont -> {next, Map.put(acc, new_sand, "o")}
        :halt -> {next, acc}
      end
    end)
    |> Map.values()
    |> Enum.count(&(&1 == "o"))
  end

  defp fall(cave, {x, y}, {min, max}, max_y, infinite_floor) do
    cond do
      cave[@start] != nil -> {:halt, {x, y}}
      infinite_floor && y == max_y -> {:cont, {x, y}}
      y > max_y -> {:halt, {x, y}}
      cave[{x, y + 1}] == nil -> fall(cave, {x, y + 1}, {min, max}, max_y, infinite_floor)
      cave[{x - 1, y + 1}] == nil -> fall(cave, {x - 1, y + 1}, {min, max}, max_y, infinite_floor)
      cave[{x + 1, y + 1}] == nil -> fall(cave, {x + 1, y + 1}, {min, max}, max_y, infinite_floor)
      true -> {:cont, {x, y}}
    end
  end
end
