defmodule AdventOfCode.Day21 do
  defp parse(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [name, yell] = String.split(l, ": ", trim: true)
      yell = String.split(yell, " ", trim: true)

      {
        name,
        if(length(yell) == 1,
          do: String.to_integer(hd(yell)),
          else: yell
        )
      }
    end)
    |> Map.new()
  end

  def part1(args) do
    map = parse(args)
    calc(map, "root")
  end

  defp calc(map, name) do
    operation(map, map[name])
  end

  defp operation(_, number) when is_number(number), do: number
  defp operation(map, [n1, "+", n2]), do: calc(map, n1) + calc(map, n2)
  defp operation(map, [n1, "*", n2]), do: calc(map, n1) * calc(map, n2)
  defp operation(map, [n1, "/", n2]), do: calc(map, n1) / calc(map, n2)
  defp operation(map, [n1, "-", n2]), do: calc(map, n1) - calc(map, n2)

  def part2(args) do
    map = parse(args)
    [left, _, right] = map["root"]

    #

    # map = Map.put(map, "humn", 3_887_609_741_189)
    map = Map.put(map, "humn", 40)
    l = calc(map, left)
    r = calc(map, right)

    [{smaller, _}, {bigger, _}] =
      Enum.sort([{left, l}, {right, r}], fn {_, v1}, {_, v2} -> v1 < v2 end)

    brute_force(map, smaller, bigger, map["humn"], map["humn"] * 2)
  end

  defp brute_force(_, _, _, res, res), do: res

  defp brute_force(map, left, right, min, max) do
    new = min + div(max - min, 2)

    map = Map.put(map, "humn", new)

    l = calc(map, left)
    r = calc(map, right)

    cond do
      l == r ->
        new

      l < r ->
        dbg({:max, max, max * 2})
        brute_force(map, left, right, max, max * 2)

      true ->
        dbg({:min, min, new})
        brute_force(map, left, right, min, new)
    end
  end

  # defp calc1(map, name) do
  #   case name do
  #     "humn" -> "?"
  #     _ -> operation1(map, map[name])
  #   end
  # end

  # defp operation1(_, number) when is_integer(number), do: number

  # defp operation1(map, [n1, "+", n2]) do
  #   v1 = calc1(map, n1)
  #   v2 = calc1(map, n2)

  #   if is_integer(v1) && is_integer(v2) do
  #     v1 + v2
  #   else
  #     "(#{v1}) + (#{v2})"
  #   end
  # end

  # defp operation1(map, [n1, "-", n2]) do
  #   v1 = calc1(map, n1)
  #   v2 = calc1(map, n2)

  #   if is_integer(v1) && is_integer(v2) do
  #     v1 - v2
  #   else
  #     "(#{v1}) - (#{v2})"
  #   end
  # end

  # defp operation1(map, [n1, "/", n2]) do
  #   v1 = calc1(map, n1)
  #   v2 = calc1(map, n2)

  #   if is_integer(v1) && is_integer(v2) do
  #     div(v1, v2)
  #   else
  #     "(#{v1}) / (#{v2})"
  #   end
  # end

  # defp operation1(map, [n1, "*", n2]) do
  #   v1 = calc1(map, n1)
  #   v2 = calc1(map, n2)

  #   if is_integer(v1) && is_integer(v2) do
  #     v1 * v2
  #   else
  #     "(#{v1}) * (#{v2})"
  #   end
  # end
end
