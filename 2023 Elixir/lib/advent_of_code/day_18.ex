defmodule AdventOfCode.Day18 do
  require Integer

  def part1(args) do
    {perimeter, vertices} =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        [[dir, num, color]] = Regex.scan(~r/(\w) (\d+) \(#(.+)\)/, line, capture: :all_but_first)
        {dir, String.to_integer(num), color}
      end)
      |> Enum.reduce({%{}, [{0, 0}]}, fn dirs, {map, [vert | _] = vertices} ->
        {m, v} = dig(map, vert, dirs)
        {m, [v | vertices]}
      end)

    (shoelace(vertices) |> abs()) / 2 + (Map.keys(perimeter) |> length()) / 2 + 1

    # {max_x, _} = Map.keys(loop_trench) |> Enum.max_by(fn {x, _} -> x end)
    # {_, max_y} = Map.keys(loop_trench) |> Enum.max_by(fn {_, y} -> y end)

    # coords = for x <- 0..max_x, y <- 0..max_y, do: {x, y}

    # Enum.reduce(coords, loop_trench, fn {r, c}, map ->
    #   if Map.get(map, {r, c}) != nil do
    #     map
    #   else
    #     if Enum.map(0..c, fn cc -> Map.get(map, {r, cc}, "000000") end)
    #        |> Enum.filter(fn color -> color != "000000" end)
    #        |> Enum.group_by(fn x -> x end)
    #        |> Enum.count()
    #        |> Integer.is_odd() do
    #       Map.put(map, {r, c}, "000000")
    #     else
    #       map
    #     end
    #   end
    # end)
    # |> print_map(display: fn x -> if x, do: "#", else: "." end)
    # |> Map.keys()
    # |> length()
  end

  defp shoelace([{x1, y1}, {x2, y2} | tail]), do: x1 * y2 - x2 * y1 + shoelace([{x2, y2} | tail])
  defp shoelace([_]), do: 0

  defp dig(map, {row, col}, {"R", num, color}),
    do: {for(c <- col..(col + num), into: map, do: {{row, c}, color}), {row, col + num}}

  defp dig(map, {row, col}, {"L", num, color}),
    do: {for(c <- (col - num)..col, into: map, do: {{row, c}, color}), {row, col - num}}

  defp dig(map, {row, col}, {"D", num, color}),
    do: {for(r <- row..(row + num), into: map, do: {{r, col}, color}), {row + num, col}}

  defp dig(map, {row, col}, {"U", num, color}),
    do: {for(r <- (row - num)..row, into: map, do: {{r, col}, color}), {row - num, col}}

  # # **********************

  # defp dig({row, col}, {"R", num, _color}), do: {row, col + num}
  # defp dig({row, col}, {"L", num, _color}), do: {row, col - num}
  # defp dig({row, col}, {"D", num, _color}), do: {row + num, col}
  # defp dig({row, col}, {"U", num, _color}), do: {row - num, col}

  def print_map(map, opts \\ []) do
    display = opts[:display] || fn x -> if x, do: x, else: "." end

    {{min_x, _}, {max_x, _}} = Map.keys(map) |> Enum.min_max_by(fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Map.keys(map) |> Enum.min_max_by(fn {_, y} -> y end)

    IO.write("\n")

    Enum.each(min_x..max_x, fn x ->
      Enum.each(min_y..max_y, fn y ->
        display.(map[{x, y}]) |> IO.write()
      end)

      IO.write("\n")
    end)

    IO.write("\n")
    map
  end

  def part2(_args) do
  end
end
