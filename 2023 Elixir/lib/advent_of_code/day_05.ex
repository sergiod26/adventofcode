defmodule AdventOfCode.Day05 do
  def part1(args) do
    {seeds, maps} = get_input(args)
    seeds |> Enum.map(fn n -> execute(n, maps) end) |> Enum.min()
  end

  defp step(num, []), do: num
  defp step(num, [{first..last, conv} | _]) when first <= num and num <= last, do: num + conv
  defp step(num, [_ | tail]), do: step(num, tail)

  defp execute(num, []), do: num
  defp execute(num, [head | tail]), do: execute(step(num, head), tail)

  def part2(args) do
    {seeds, maps} = get_input(args)

    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn [s, r] -> s..(s + r - 1) end)
    |> execute_range(maps)
    |> Enum.map(fn first.._ -> first end)
    |> Enum.min()
  end

  defp step_range(num_range, []), do: [num_range]

  defp step_range(first..last, [{map_first..map_last, conv} | tail]) do
    cond do
      # subset
      first >= map_first && last <= map_last ->
        [(first + conv)..(last + conv)]

      # superset
      first <= map_first && last >= map_last ->
        [
          (map_first + conv)..(map_last + conv)
          | step_range(first..(map_first - 1), tail)
        ] ++ step_range((map_last + 1)..last, tail)

      # right
      first >= map_first && first <= map_last ->
        [(first + conv)..(map_last + conv) | step_range((map_last + 1)..last, tail)]

      # left
      last >= map_first && last <= map_last ->
        [(map_first + conv)..(last + conv) | step_range(first..(map_first - 1), tail)]

      true ->
        step_range(first..last, tail)
    end
  end

  defp execute_range(num_range, []), do: num_range

  defp execute_range(num_range, [head | tail]),
    do:
      execute_range(
        num_range |> Enum.reduce([], fn n, acc -> step_range(n, head) ++ acc end),
        tail
      )

  defp get_input(args) do
    ["seeds: " <> seeds | rest] = args |> String.split("\n\n", trim: true)

    seeds_nums = seeds |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)

    maps =
      rest
      |> Enum.map(fn l ->
        String.split(l, "\n", trim: true)
        # dont care about the "titles"
        |> Enum.drop(1)
        |> Enum.map(fn x ->
          [dest, src, range] = String.split(x, " ", trim: true) |> Enum.map(&String.to_integer/1)
          # using offset instead of extra range
          # 50 98 2 will become {98..99, -48}
          # meaning, any value between 98 and 99 will be changed by -48
          {src..(src + range - 1), dest - src}
        end)
      end)

    {seeds_nums, maps}
  end
end
