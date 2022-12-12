# Im too old for this... thought of dijkstra by myself, but didn't want to implement it
# ~Stole~ took some inspiration from cfbender to parse a matrix into an array of coordinates
# And plug it into Elixir.Graph.Pathfinding.dijkstra

defmodule AdventOfCode.Day12 do
  def part1(args) do
    {graph, first, last, _} = setup_graph(args)
    length(Elixir.Graph.Pathfinding.dijkstra(graph, first, last)) - 1
  end

  def part2(args) do
    {graph, _, last, vertices} = setup_graph(args)

    vertices
    |> Enum.filter(fn {_, v} -> v == ?a end)
    |> Enum.map(fn {pos, _} ->
      result = Elixir.Graph.Pathfinding.dijkstra(graph, pos, last)
      if(result == nil, do: :infinity, else: length(result) - 1)
    end)
    |> Enum.min()
  end

  defp in_boundary({x, y}, size_x, size_y), do: x < size_x && x >= 0 && y < size_y && x >= 0

  defp setup_graph(args) do
    matrix =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_charlist/1)

    size_x = length(matrix)
    size_y = length(Enum.at(matrix, 0))

    vertices =
      matrix
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, iy}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {v, ix}, acc_row -> Map.put(acc_row, {iy, ix}, v) end)
      end)

    {first, _} = Enum.find(vertices, fn {_, v} -> v == ?S end)
    {last, _} = Enum.find(vertices, fn {_, v} -> v == ?E end)

    vertices = Map.put(vertices, first, ?a) |> Map.put(last, ?z)

    edges =
      vertices
      |> Enum.reduce([], fn {{x, y}, val}, acc ->
        neighbors =
          [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
          |> Enum.map(fn {a, b} ->
            neighbor = {x + a, y + b}

            if in_boundary(neighbor, size_x, size_y) && val + 1 >= vertices[neighbor],
              do: {{x, y}, neighbor}
          end)
          |> Enum.filter(&(&1 != nil))

        neighbors ++ acc
      end)

    g =
      Graph.new()
      |> Graph.add_vertices(Enum.map(vertices, fn {pos, _} -> pos end))
      |> Graph.add_edges(edges)

    {g, first, last, vertices}
  end
end
