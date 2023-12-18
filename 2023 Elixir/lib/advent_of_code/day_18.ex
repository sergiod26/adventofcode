defmodule AdventOfCode.Day18 do
  require Integer

  def part1(args) do
    {vertices, perimeter} =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        [[dir, num, _]] = Regex.scan(~r/(\w) (\d+) \(#(.+)\)/, line, capture: :all_but_first)
        {dir, String.to_integer(num)}
      end)
      |> Enum.reduce({[{0, 0}], 0}, fn dirs, {[vert | _] = vertices, perimeter} ->
        {[dig(vert, dirs) | vertices], perimeter + elem(dirs, 1)}
      end)

    (shoelace(vertices) |> abs()) / 2 + perimeter / 2 + 1
  end

  def part2(args) do
    {vertices, perimeter} =
      String.split(args, "\n", trim: true)
      |> Enum.map(fn line ->
        [[num, dir]] = Regex.scan(~r/\w \d+ \(#(.....)(.)\)/, line, capture: :all_but_first)

        dir =
          case dir do
            "0" -> "R"
            "1" -> "D"
            "2" -> "L"
            "3" -> "U"
          end

        {dir, String.to_integer(num, 16)}
      end)
      |> Enum.reduce({[{0, 0}], 0}, fn dirs, {[vert | _] = vertices, perimeter} ->
        {[dig(vert, dirs) | vertices], perimeter + elem(dirs, 1)}
      end)

    (shoelace(vertices) |> abs()) / 2 + perimeter / 2 + 1
  end

  defp shoelace([{x1, y1}, {x2, y2} | tail]), do: x1 * y2 - x2 * y1 + shoelace([{x2, y2} | tail])
  defp shoelace([_]), do: 0

  defp dig({row, col}, {"R", num}), do: {row, col + num}
  defp dig({row, col}, {"L", num}), do: {row, col - num}
  defp dig({row, col}, {"D", num}), do: {row + num, col}
  defp dig({row, col}, {"U", num}), do: {row - num, col}
end
