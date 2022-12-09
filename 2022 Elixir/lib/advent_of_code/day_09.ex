# Lots of iterations
# move_tail is the basic rules
# iterate over the movements, saving a set of the positions where the tail has been
#  remember the last position for both, tail and head (on part 2, extend to have a head and 8 nodes behaving like tails)

defmodule AdventOfCode.Day09 do
  def part1(args) do
    {_, _, final_path} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn l ->
        [dir, qt] = String.split(l, " ")
        {dir, String.to_integer(qt)}
      end)
      # {head, tail, tail's path (mapset, ignore dupes)}
      |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new([])}, fn {dir, qt}, acc ->
        1..qt
        |> Enum.reduce(acc, fn _, {head, tail, path} ->
          new_head = move_head(dir, head)
          new_tail = move_tail(new_head, tail)
          {new_head, new_tail, MapSet.put(path, new_tail)}
        end)
      end)

    MapSet.size(final_path)
  end

  def part2(args) do
    {_, final_path} =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn l ->
        [dir, qt] = String.split(l, " ")
        {dir, String.to_integer(qt)}
      end)
      # Use a map with the positions of every knot
      |> Enum.reduce({0..9 |> Map.new(&{&1, {0, 0}}), MapSet.new([])}, fn {dir, qt}, acc ->
        1..qt
        |> Enum.reduce(acc, fn _, {rope, path} ->
          rope = %{rope | 0 => move_head(dir, Map.get(rope, 0))}

          # There is probably a better way...
          # but just ignore the real tail in the loop
          # since we need to use it later for the path
          rope =
            0..7
            |> Enum.reduce(rope, fn ix, acc ->
              %{acc | (ix + 1) => move_tail(Map.get(acc, ix), Map.get(acc, ix + 1))}
            end)

          # Once more, same as before but for the "real tail"
          new_tail = move_tail(Map.get(rope, 8), Map.get(rope, 9))
          {%{rope | 9 => new_tail}, MapSet.put(path, new_tail)}
        end)
      end)

    MapSet.size(final_path)
  end

  defp move_head(dir, {hx, hy}) do
    case dir do
      "R" -> {hx + 1, hy}
      "L" -> {hx - 1, hy}
      "U" -> {hx, hy + 1}
      "D" -> {hx, hy - 1}
    end
  end

  defp move_tail({hx, hy}, {tx, ty}) do
    cond do
      hx - tx > 1 && hy - ty > 1 -> {tx + 1, ty + 1}
      hx - tx < -1 && hy - ty < -1 -> {tx - 1, ty - 1}
      hx - tx > 1 && hy - ty < -1 -> {tx + 1, ty - 1}
      hx - tx < -1 && hy - ty > 1 -> {tx - 1, ty + 1}
      hx - tx > 1 -> {tx + 1, hy}
      hx - tx < -1 -> {tx - 1, hy}
      hy - ty > 1 -> {hx, ty + 1}
      hy - ty < -1 -> {hx, ty - 1}
      true -> {tx, ty}
    end
  end
end
