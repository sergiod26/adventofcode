defmodule AdventOfCode.Day17 do
  def part1(args) do
    matrix =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)

    size_x = length(matrix)
    size_y = length(Enum.at(matrix, 0))

    vertices =
      Enum.with_index(matrix)
      |> Enum.reduce(%{}, fn {row, iy}, acc ->
        Enum.reduce(Enum.with_index(row), acc, fn {v, ix}, acc_row ->
          Map.put(acc_row, {iy, ix}, String.to_integer(v))
        end)
      end)

    edges =
      vertices
      |> Enum.reduce([], fn {{x, y}, _}, acc ->
        neighbors_hor =
          Enum.map([-1, 1], fn b ->
            Enum.reduce(1..3, {0, []}, fn i, {prev_heat, acc} ->
              neighbor = {x, y + i * b}

              if in_boundary(neighbor, size_x, size_y) do
                heat = prev_heat + vertices[neighbor]
                {heat, [{{{x, y}, :horizontal}, {neighbor, :vertical}, weight: heat} | acc]}
              else
                {prev_heat, acc}
              end
            end)
            |> elem(1)
          end)

        neighbors_ver =
          Enum.map([-1, 1], fn a ->
            Enum.reduce(1..3, {0, []}, fn i, {prev_heat, acc} ->
              neighbor = {x + i * a, y}

              if in_boundary(neighbor, size_x, size_y) do
                heat = prev_heat + vertices[neighbor]
                {heat, [{{{x, y}, :vertical}, {neighbor, :horizontal}, weight: heat} | acc]}
              else
                {prev_heat, acc}
              end
            end)
            |> elem(1)
          end)

        neighbors_hor ++ neighbors_ver ++ acc
      end)
      |> List.flatten()

    edges = [
      {"start", {{0, 0}, :vertical}, weight: 0},
      {"start", {{0, 0}, :horizontal}, weight: 0},
      {{{size_x - 1, size_y - 1}, :vertical}, "end", weight: 0},
      {{{size_x - 1, size_y - 1}, :horizontal}, "end", weight: 0}
      | edges
    ]

    g =
      Graph.new()
      |> Graph.add_vertices(Enum.map(vertices, fn {pos, _} -> pos end))
      |> Graph.add_edges(edges)

    path = Graph.get_shortest_path(g, "start", "end")

    sum_path(g, path)
  end

  def part2(args) do
    matrix =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)

    size_x = length(matrix)
    size_y = length(Enum.at(matrix, 0))

    vertices =
      Enum.with_index(matrix)
      |> Enum.reduce(%{}, fn {row, iy}, acc ->
        Enum.reduce(Enum.with_index(row), acc, fn {v, ix}, acc_row ->
          Map.put(acc_row, {iy, ix}, String.to_integer(v))
        end)
      end)

    edges =
      vertices
      |> Enum.reduce([], fn {{x, y}, _}, acc ->
        neighbors_hor =
          Enum.map([-1, 1], fn b ->
            new_heat =
              Enum.reduce((y + 1 * b)..(y + 3 * b), 0, fn yy, acc ->
                Map.get(vertices, {x, yy}, 0) + acc
              end)

            Enum.reduce(4..10, {new_heat, []}, fn i, {prev_heat, acc} ->
              neighbor = {x, y + i * b}

              if in_boundary(neighbor, size_x, size_y) do
                heat = prev_heat + vertices[neighbor]
                {heat, [{{{x, y}, :horizontal}, {neighbor, :vertical}, weight: heat} | acc]}
              else
                {prev_heat, acc}
              end
            end)
            |> elem(1)
          end)

        neighbors_ver =
          Enum.map([-1, 1], fn a ->
            new_heat =
              Enum.reduce((x + 1 * a)..(x + 3 * a), 0, fn xx, acc ->
                Map.get(vertices, {xx, y}, 0) + acc
              end)

            Enum.reduce(4..10, {new_heat, []}, fn i, {prev_heat, acc} ->
              neighbor = {x + i * a, y}

              if in_boundary(neighbor, size_x, size_y) do
                heat = prev_heat + vertices[neighbor]
                {heat, [{{{x, y}, :vertical}, {neighbor, :horizontal}, weight: heat} | acc]}
              else
                {prev_heat, acc}
              end
            end)
            |> elem(1)
          end)

        neighbors_hor ++ neighbors_ver ++ acc
      end)
      |> List.flatten()

    edges = [
      {"start", {{0, 0}, :vertical}, weight: 0},
      {"start", {{0, 0}, :horizontal}, weight: 0},
      {{{size_x - 1, size_y - 1}, :vertical}, "end", weight: 0},
      {{{size_x - 1, size_y - 1}, :horizontal}, "end", weight: 0}
      | edges
    ]

    g =
      Graph.new()
      |> Graph.add_vertices(Enum.map(vertices, fn {pos, _} -> pos end))
      |> Graph.add_edges(edges)

    path = Graph.get_shortest_path(g, "start", "end")

    sum_path(g, path)
  end

  defp sum_path(g, [f, s | t]),
    do: (Graph.edge(g, f, s) |> Map.get(:weight)) + sum_path(g, [s | t])

  defp sum_path(_, _), do: 0

  defp in_boundary({x, y}, size_x, size_y), do: x < size_x && x >= 0 && y < size_y && y >= 0
end
