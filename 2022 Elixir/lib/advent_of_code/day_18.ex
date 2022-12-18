defmodule AdventOfCode.Day18 do
  @deltas [{-1, 0, 0}, {1, 0, 0}, {0, -1, 0}, {0, 1, 0}, {0, 0, -1}, {0, 0, 1}]

  # Returns something like `{12, 9, 18} => true, {11, 4, 5} => true, {2, 10, 6} => true,...`
  # values don't really matter, should I find a better data structure that allow indexed access?
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, ",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Map.new(fn k -> {k, true} end)
    |> dbg()
  end

  # Count how many neighbors, 6 faces - #neighbors is the sides exposed
  def part1(args) do
    cube = parse(args)

    Map.keys(cube)
    |> Enum.map(fn {x, y, z} ->
      length(Enum.filter(@deltas, fn {dx, dy, dz} -> cube[{x + dx, y + dy, z + dz}] end))
    end)
    |> Enum.map(&(6 - &1))
    |> Enum.sum()
  end

  def part2(args) do
    cube = parse(args)

    {{min_x, _, _}, {max_x, _, _}} = Map.keys(cube) |> Enum.min_max_by(fn {x, _, _} -> x end)
    {{_, min_y, _}, {_, max_y, _}} = Map.keys(cube) |> Enum.min_max_by(fn {_, y, _} -> y end)
    {{_, _, min_z}, {_, _, max_z}} = Map.keys(cube) |> Enum.min_max_by(fn {_, _, z} -> z end)
    min = Enum.min([min_x, min_y, min_z])
    max = Enum.max([max_x, max_y, max_z])

    # List of all positions reacheable (no air pocket can be reached)
    visited =
      (calc(
         cube,
         [],
         [{min, min, min}],
         {min, min, min},
         {max, max, max}
       ) ++ Map.keys(cube))
      |> Enum.uniq()

    # Who cares about perfomance? Traverse again the whole cube to get the
    # positions that weren't visited
    empties =
      for x <- min..max,
          y <- min..max,
          z <- min..max do
        if !Enum.member?(visited, {x, y, z}) do
          {x, y, z}
        end
      end
      # This beauty will generate a lot of nils... ignore them
      |> Enum.filter(& &1)
      |> Map.new(fn x -> {x, true} end)

    # Empties will behave as if they were lava, aka sides won't be counted
    cube = Map.merge(cube, empties)

    # Do the same as part 1, with the new map
    Map.keys(cube)
    |> Enum.map(fn {x, y, z} ->
      length(Enum.filter(@deltas, fn {dx, dy, dz} -> cube[{x + dx, y + dy, z + dz}] end))
    end)
    |> Enum.map(&(6 - &1))
    |> Enum.sum()
  end

  defp calc(_, visited, [], _, _), do: visited

  defp calc(
         cube,
         visited,
         [{x, y, z} = h | tail],
         {min_x, min_y, min_z} = min,
         {max_x, max_y, max_z} = max
       ) do
    # if position is lava or already visited, add to visited and drop from pending
    # ignoring lava positions, it shouldn't be possible to reach pockets of air
    if cube[h] || Enum.member?(visited, h) do
      calc(cube, [h | visited], tail, min, max)

      # otherwise add all neighbors between bounds that haven't been visited to the pending (droping current)
      # add current to visited
    else
      neighbors =
        Enum.map(@deltas, fn {dx, dy, dz} -> {x + dx, y + dy, z + dz} end)
        |> Enum.filter(fn {x, y, z} ->
          x >= min_x && y >= min_y && z >= min_z && x <= max_x && y <= max_y && z <= max_z &&
            !Enum.member?(visited, {x, y, z})
        end)

      calc(cube, [h | visited], tail ++ neighbors, min, max)
    end
  end
end
