defmodule AdventOfCode.Day25 do
  # Attempt of Karger's algorithm

  def part1(args) do
    edges =
      String.split(args, "\n", trim: true)
      |> Enum.reduce([], fn line, acc ->
        [h | t] = String.split(line, [":", " "], trim: true)
        Enum.map(t, fn con -> {h, con} end) ++ acc
      end)

    g = Graph.new() |> Graph.add_edges(edges)

    reduce_graph(g)
    |> Graph.vertices()
    |> Enum.map(fn v -> String.split(v, " ") |> length() end)
    |> Enum.reduce(1, fn l, acc -> l * acc end)
  end

  defp min_cut(g, 2), do: g

  defp min_cut(g, _) do
    %Graph.Edge{v1: a, v2: b} = Graph.edges(g) |> Enum.random()

    ab = "#{a} #{b}"

    tmp_edges =
      Graph.neighbors(g, b)
      |> Enum.map(fn v -> if v != a, do: {ab, v} end)
      |> Enum.filter(fn x -> !is_nil(x) end)

    gg =
      Graph.replace_vertex(g, a, ab)
      |> Graph.delete_vertex(b)
      |> Graph.add_edges(tmp_edges)

    min_cut(gg, length(Graph.vertices(gg)))
  end

  defp reduce_graph(g) do
    graph = min_cut(g, 0)
    cuts = with_cache({g, graph}, fn -> count_cuts(g, graph) end)

    if cuts == 3 do
      graph
    else
      reduce_graph(g)
    end
  end

  defp count_cuts(g, graph) do
    nodes =
      Graph.vertices(graph)
      |> List.first()
      |> String.split(" ")

    nodes
    |> Enum.reduce([], fn v, acc ->
      (Graph.neighbors(g, v)
       |> Enum.map(fn x ->
         if !(x in nodes && v in nodes) && {x, v} not in acc && {v, x} not in acc, do: {v, x}
       end)) ++ acc
    end)
    |> Enum.filter(fn x -> !is_nil(x) end)
    |> length()
  end

  def part2(_args) do
  end

  defp with_cache(key, fun) do
    with nil <- Process.get(key) do
      fun.() |> tap(&Process.put(key, &1))
    end
  end
end
