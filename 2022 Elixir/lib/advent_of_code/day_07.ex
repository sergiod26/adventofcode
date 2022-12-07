# 1) Create the whole tree? (probably to wasteful)

# 2) Delete all "$ ls" and "dir X"
#     Use the dir in cd D and just accumulate size (use a map?)
#     On cd .. add total to previous (stack with the hierarchy?)

# 3) Give up and create the freaking tree in the least performant way possible (also... is this OOP?)

defmodule AdventOfCode.Day07 do
  defp build_tree(args) do
    gr = :digraph.new()
    :digraph.add_vertex(gr, "/", 0)

    args
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.scan(["/"], fn
      "$ cd ..", [_ | acc] ->
        acc

      "$ cd " <> dir, [h | _] = acc ->
        path = "#{h} #{dir}"
        :digraph.add_vertex(gr, path, 0)
        :digraph.add_edge(gr, h, path)
        [path | acc]

      "dir " <> _, acc ->
        acc

      "$ ls" <> _, acc ->
        acc

      file, [h | _] = acc ->
        [size, _] = String.split(file, " ")

        {_, old_size} = :digraph.vertex(gr, h)
        :digraph.add_vertex(gr, h, String.to_integer(size) + old_size)

        acc
    end)

    gr
  end

  def part1(args) do
    gr = build_tree(args)

    :digraph.vertices(gr)
    |> Enum.map(&size(gr, &1))
    |> Stream.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  def part2(args) do
    gr = build_tree(args)

    dirs =
      :digraph.vertices(gr)
      |> Enum.map(&size(gr, &1))
      |> Enum.sort()

    available =
      70_000_000 -
        (dirs
         |> Enum.at(-1))

    dirs
    |> Enum.drop_while(&(available + &1 < 30_000_000))
    |> hd
  end

  defp size(gr, node) do
    {_, size} = :digraph.vertex(gr, node)

    children =
      :digraph.out_neighbours(gr, node)
      |> Enum.map(fn v -> size(gr, v) end)
      |> Enum.sum()

    children + size
  end
end
