defmodule AdventOfCode.Day13 do
  require Integer

  def part1(args) do
    {c, r} =
      args
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn pattern -> String.split(pattern, "\n", trim: true) end)
      |> Enum.map(&find_reflection/1)
      |> Enum.reduce({0, 0}, fn {c, r}, {tc, tr} -> {c + tc, r + tr} end)

    100 * r + c
  end

  # pattern = ["...", "...", "...", ...]
  defp find_reflection(pattern, {av_hor, av_ver} \\ {-1, -1}) do
    reversed = Enum.reverse(pattern)

    vertical =
      with 0 <- solve(pattern, reversed, 0, 1, av_ver), do: solve(reversed, pattern, 0, 0, av_ver)

    tr = transpose(Enum.map(pattern, &String.codepoints/1)) |> Enum.map(&Enum.join/1)
    rev_tr = Enum.reverse(tr)

    horizontal = with 0 <- solve(tr, rev_tr, 0, 1, av_hor), do: solve(rev_tr, tr, 0, 0, av_hor)

    {horizontal, vertical}
  end

  defp solve([_], _, _ix, _rev, _), do: 0

  defp solve([_ | t1] = list1, list2, ix, rev, avoid) do
    len = length(list1)
    key = div(len, 2) + ix * rev

    if key != avoid && Integer.is_even(len) && List.starts_with?(list2, list1),
      do: key,
      else: solve(t1, list2, ix + 1, rev, avoid)
  end

  def transpose(rows), do: List.zip(rows) |> Enum.map(&Tuple.to_list/1)

  def part2(args) do
    {c, r} =
      args
      |> String.split("\n\n", trim: true)
      |> Enum.map(fn pattern -> String.split(pattern, "\n", trim: true) end)
      |> Enum.map(fn pattern ->
        original_reflections = find_reflection(pattern)
        pattern = Enum.map(pattern, &String.codepoints/1)
        height = length(pattern) - 1
        width = length(Enum.at(pattern, 0)) - 1

        coords = for row <- 0..height, col <- 0..width, do: {row, col}

        Enum.reduce_while(coords, [], fn {r, c}, _ ->
          symbol = if Enum.at(Enum.at(pattern, r), c) == "#", do: ".", else: "#"

          new_pattern =
            List.replace_at(pattern, r, Enum.at(pattern, r) |> List.replace_at(c, symbol))
            |> Enum.map(&Enum.join/1)

          case find_reflection(new_pattern, original_reflections) do
            {0, 0} -> {:cont, {0, 0}}
            success -> {:halt, success}
          end
        end)
      end)
      |> Enum.reduce({0, 0}, fn {c, r}, {tc, tr} -> {c + tc, r + tr} end)

    100 * r + c
  end
end
