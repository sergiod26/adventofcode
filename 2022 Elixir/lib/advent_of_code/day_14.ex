# Stuck in part1 for a while because I assumed there were rocks
# from the smallest x to the highest one (like in the example)

defmodule AdventOfCode.Day14 do
  # Returns a list of coordinates with all rock spaces
  # %{{494, 9} => "#",{495, 9} => "#",{496, 6} => "#",...}
  defp parse(args) do
    cave =
      args
      |> String.split("\n", trim: true)
      |> Enum.flat_map(fn l ->
        String.split(l, " -> ", trim: true)
        |> Enum.map(fn coord ->
          [x, y] = String.split(coord, ",")
          {String.to_integer(x), String.to_integer(y)}
        end)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.flat_map(fn [{x1, y1}, {x2, y2}] ->
          if x1 == x2,
            do: y1..y2 |> Enum.map(&{x1, &1}),
            else: x1..x2 |> Enum.map(&{&1, y1})
        end)
      end)
      |> Map.new(&{&1, "#"})

    {min_x, _} = Map.keys(cave) |> Enum.min_by(fn {x, _} -> x end)
    {max_x, _} = Map.keys(cave) |> Enum.max_by(fn {x, _} -> x end)
    {_, max_y} = Map.keys(cave) |> Enum.max_by(fn {_, y} -> y end)

    {cave, min_x, max_x, max_y}
  end

  def part1(args) do
    {cave, min_x, max_x, max_y} = parse(args)

    {res, _} =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while({0, cave}, fn ix, {_, acc} ->
        {next, new_sand} = fall(acc, {500, 0}, {min_x, max_x}, max_y)
        {next, {ix, Map.put(acc, new_sand, "o")}}
      end)

    res
  end

  def part2(args) do
    {cave, min_x, max_x, max_y} = parse(args)

    {res, _} =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while({0, cave}, fn ix, {_, acc} ->
        {next, new_sand} = fall(acc, {500, 0}, {min_x, max_x}, max_y + 1, true)

        next =
          case new_sand do
            {500, 0} -> :halt
            _ -> next
          end

        {next, {ix, Map.put(acc, new_sand, "o")}}
      end)

    res + 1
  end

  defp fall(cave, {x, y}, {min, max}, max_y, infinite_floor \\ false) do
    cond do
      infinite_floor && y == max_y -> {:cont, {x, y}}
      y > max_y -> {:halt, {x, y}}
      cave[{x, y + 1}] == nil -> fall(cave, {x, y + 1}, {min, max}, max_y, infinite_floor)
      cave[{x - 1, y + 1}] == nil -> fall(cave, {x - 1, y + 1}, {min, max}, max_y, infinite_floor)
      cave[{x + 1, y + 1}] == nil -> fall(cave, {x + 1, y + 1}, {min, max}, max_y, infinite_floor)
      true -> {:cont, {x, y}}
    end
  end
end
