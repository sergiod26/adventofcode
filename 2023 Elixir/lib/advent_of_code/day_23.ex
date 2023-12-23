defmodule AdventOfCode.Day23 do
  def part1(args) do
    solve(args)
  end

  def part2(args) do
    solve(args, fn _ -> "." end)
  end

  defp solve(args, type \\ fn x -> x end) do
    matrix =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)

    start = {0, Enum.find_index(Enum.at(matrix, 0), fn x -> x == "." end)}
    finish = {length(matrix) - 1, Enum.find_index(Enum.at(matrix, -1), fn x -> x == "." end)}

    vertices =
      Enum.with_index(matrix)
      |> Enum.reduce(%{}, fn {row, iy}, acc ->
        Enum.reduce(Enum.with_index(row), acc, fn {v, ix}, acc_row ->
          if v == "#" do
            acc_row
          else
            Map.put(acc_row, {iy, ix}, type.(v))
          end
        end)
      end)

    edges =
      vertices
      |> Enum.reduce([], fn {{x, y}, val}, acc ->
        neighbors =
          [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
          |> Enum.map(fn {a, b} ->
            if Map.has_key?(vertices, {x + a, y + b}), do: neighbor({x, y}, val, {a, b})
          end)
          |> Enum.filter(&(&1 != nil))

        neighbors ++ acc
      end)

    g =
      Graph.new()
      |> Graph.add_vertices(Enum.map(vertices, fn {pos, _} -> pos end))
      |> Graph.add_edges(edges)

    Graph.get_paths(g, start, finish)
    |> Enum.map(fn p -> length(p) - 1 end)
    |> Enum.max()
  end

  defp neighbor({x, y}, "<", {0, -1}), do: {{x, y}, {x, y - 1}, weight: -1}
  defp neighbor({x, y}, ">", {0, 1}), do: {{x, y}, {x, y + 1}, weight: -1}
  defp neighbor({x, y}, "^", {-1, 0}), do: {{x, y}, {x - 1, y}, weight: -1}
  defp neighbor({x, y}, "v", {1, 0}), do: {{x, y}, {x + 1, y}, weight: -1}
  defp neighbor({x, y}, ".", {a, b}), do: {{x, y}, {x + a, y + b}, weight: -1}
  defp neighbor(_, _, _), do: nil
end
