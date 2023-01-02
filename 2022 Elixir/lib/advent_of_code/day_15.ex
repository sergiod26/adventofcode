defmodule AdventOfCode.Day15 do
  def part1(args) do
    {sensors, beacons} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn l ->
        Regex.scan(~r/-?\d+/, l)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.reduce({[], %{}}, fn [x1, y1, x2, y2], {sensors, beacons} ->
        {
          [{{x1, y1}, distance({x1, y1}, {x2, y2})} | sensors],
          Map.put(beacons, {x2, y2}, true)
        }
      end)

    {min, max} =
      sensors
      |> Enum.flat_map(fn {{x, _}, dist} -> [x - dist, x + dist] end)
      |> Enum.min_max()

    row = 2_000_000

    Enum.reduce(min..max, 0, fn x, count ->
      if !beacons[{x, row}] &&
           Enum.any?(sensors, fn {coord, dist} -> distance(coord, {x, row}) <= dist end) do
        count + 1
      else
        count
      end
    end)
  end

  defp distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def part2(args) do
    {sensors, beacons} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn l ->
        Regex.scan(~r/-?\d+/, l)
        |> List.flatten()
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.reduce({[], %{}}, fn [x1, y1, x2, y2], {sensors, beacons} ->
        {
          [{{x1, y1}, distance({x1, y1}, {x2, y2})} | sensors],
          Map.put(beacons, {x2, y2}, true)
        }
      end)

    limit = 4_000_000

    Enum.map(0..limit, fn row ->
      dbg(row)

      Enum.reduce(sensors, [], fn {{x, y}, dist}, acc ->
        diff = abs(row - y)

        if diff > dist do
          acc
        else
          [(x - dist + diff)..(x + dist - diff) | acc]
        end
      end)
      |> Enum.sort()
    end)
    # |> Enum.with_index()
    # |> Enum.reduce_while(0, fn {ranges, ix}, _ ->
    #   if(is_range(ranges), do: {:cont, ix}, else: {:halt, ix})
    # end)
    |> dbg()

    # # row = 2_000_000
    # min = 4_000_000
    # max = 0

    # Enum.map(min..max, fn row ->
    #   Task.async(fn ->
    #     if rem(row, 1000) == 0 do
    #       IO.write("#{row}\n")
    #     end

    #     Enum.each(min..max, fn x ->
    #       if !beacons[{x, row}] &&
    #            !Enum.any?(sensors, fn {coord, dist} -> distance(coord, {x, row}) <= dist end) do
    #         IO.write(". #{{x, row}}")
    #       end
    #     end)
    #   end)
    # end)
    # |> Enum.map(&Task.await/1)
  end

  defp is_range([a | [b | tail]]) do
    # dbg({a, b})

    if(Range.disjoint?(a, b),
      do: false,
      else: is_range([min(a.first, b.first)..max(a.last, b.last) | tail])
    )
  end

  defp is_range(_), do: true
end
