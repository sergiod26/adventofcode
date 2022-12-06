# 1. A moving windows should do
# 2. Exactly the smae

defmodule AdventOfCode.Day06 do
  def part1(args) do
    args |> go(4)
  end

  def part2(args) do
    args |> go(14)
  end

  defp go(input, window) do
    {_, ix} =
      input
      |> String.graphemes()
      |> Stream.chunk_every(window, 1)
      |> Stream.with_index()
      |> Stream.drop_while(fn {l, _} -> Enum.uniq(l) |> length != window end)
      |> Enum.at(0)

    ix + window
  end
end
