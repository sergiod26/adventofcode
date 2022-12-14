defmodule AdventOfCode.Helpers do
  def print_map(map, opts \\ []) do
    display = opts[:display] || fn x -> if x, do: x, else: "." end

    {{min_x, _}, {max_x, _}} = Map.keys(map) |> Enum.min_max_by(fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Map.keys(map) |> Enum.min_max_by(fn {_, y} -> y end)

    IO.write("\n")

    Enum.each(min_y..max_y, fn y ->
      Enum.each(min_x..max_x, fn x ->
        display.(map[{x, y}]) |> IO.write()
      end)

      IO.write("\n")
    end)

    IO.write("\n")
    map
  end
end
