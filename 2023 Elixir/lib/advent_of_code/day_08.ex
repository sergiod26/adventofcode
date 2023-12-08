defmodule AdventOfCode.Day08 do
  def part1(args) do
    {dirs, map} = get_inpu(args)

    Enum.reduce_while(Stream.cycle(dirs), {1, "AAA"}, fn dir, {c, next} ->
      tmp = map[next][dir]

      if(is_nil(tmp) || tmp == "ZZZ") do
        {:halt, c}
      else
        {:cont, {c + 1, tmp}}
      end
    end)
  end

  def part2(args) do
    {dirs, map} = get_inpu(args)

    starts = Map.keys(map) |> Enum.filter(fn x -> String.ends_with?(x, "A") end)

    starts
    |> Enum.map(fn s ->
      Enum.reduce_while(Stream.cycle(dirs), {1, s}, fn dir, {c, next} ->
        tmp = map[next][dir]

        if(is_nil(tmp) || String.ends_with?(tmp, "Z")) do
          {:halt, c}
        else
          {:cont, {c + 1, tmp}}
        end
      end)
    end)
    |> Enum.reduce(&div(&1 * &2, Integer.gcd(&1, &2)))
  end

  defp get_inpu(args) do
    [dir | tail] = args |> String.split("\n", trim: true)

    dirs = String.codepoints(dir)

    map =
      tail
      |> Enum.reduce(%{}, fn l, acc ->
        [[node, l, r]] = Regex.scan(~r/(...) = \((...), (...)\)/, l, capture: :all_but_first)

        Map.put(acc, node, %{"L" => l, "R" => r})
      end)

    {dirs, map}
  end
end
