defmodule AdventOfCode.Day05 do
  def part1(args) do
    ["seeds: " <> seeds | rest] =
      args
      |> String.split("\n\n", trim: true)

    seeds_nums = seeds |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

    maps =
      rest
      |> Enum.map(fn l ->
        String.split(l, "\n", trim: true)
        |> Enum.drop(1)
        |> Enum.map(fn x ->
          [destination, source, range] =
            String.split(x, " ", trim: true) |> Enum.map(&String.to_integer/1)

          {source..(source + range), destination - source}
        end)
      end)

    seeds_nums |> Enum.map(fn n -> step_out(n, maps) end) |> Enum.min()
  end

  defp step(num, []), do: num

  defp step(num, [{range, conv} | tail]) do
    if(num in range) do
      num + conv
    else
      step(num, tail)
    end
  end

  defp step_out(num, []), do: num

  defp step_out(num, [head | tail]) do
    step_out(step(num, head), tail)
  end

  def part2(args) do
    ["seeds: " <> seeds | rest] =
      args
      |> String.split("\n\n", trim: true)

    seeds_nums =
      seeds
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [s, r] -> s..(s + r) end)

    maps =
      rest
      |> Enum.map(fn l ->
        String.split(l, "\n", trim: true)
        |> Enum.drop(1)
        |> Enum.map(fn x ->
          [destination, source, range] =
            String.split(x, " ", trim: true) |> Enum.map(&String.to_integer/1)

          {source..(source + range - 1), destination - source}
        end)
      end)

    step_range_out(seeds_nums, maps) |> Enum.map(fn first.._ -> first end) |> Enum.min()
  end

  defp step_range(num_range, []), do: [num_range]

  defp step_range(first..last = num_range, [{map_first..map_last, conv} | tail]) do
    cond do
      first >= map_first && last <= map_last ->
        [(first + conv)..(last + conv)]

      first <= map_first && last >= map_last ->
        [(map_first + conv)..(map_last + conv)] ++
          step_range(first..(map_first - 1), tail) ++
          step_range((map_last + 1)..last, tail)

      first >= map_first && first <= map_last ->
        [(first + conv)..(map_last + conv) | step_range((map_last + 1)..last, tail)]

      last >= map_first && last <= map_last ->
        [(map_first + conv)..(last + conv) | step_range(first..(map_first - 1), tail)]

      true ->
        step_range(num_range, tail)
    end
  end

  defp step_range_out(num, []), do: num

  defp step_range_out(num_range, [head | tail]) do
    step_range_out(
      num_range |> Enum.reduce([], fn n, acc -> step_range(n, head) ++ acc end),
      tail
    )
  end
end
