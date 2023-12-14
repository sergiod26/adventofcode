defmodule AdventOfCode.Day14 do
  def part1(args) do
    matrix = String.split(args, "\n", trim: true)
    rows_size = length(matrix)

    matrix
    |> tilt()
    |> Enum.reduce({rows_size, 0}, fn row, {ix, acc} ->
      {ix - 1, acc + Enum.count(row, &(&1 == "O")) * ix}
    end)
    |> elem(1)
  end

  defp tilt(matrix) do
    matrix
    |> transpose()
    |> Enum.map(&Enum.join/1)
    |> Enum.map(fn row ->
      String.split(row, "#")
      |> Enum.map(fn segment ->
        segment = String.codepoints(segment)
        num_rocks = Enum.count(segment, &(&1 == "O"))
        len = length(segment)
        String.duplicate("O", num_rocks) <> String.duplicate(".", len - num_rocks)
      end)
      |> Enum.join("#")
    end)
    |> transpose()
  end

  def part2(args, cycles \\ 1_000_000_000) do
    matrix = String.split(args, "\n", trim: true)
    rows_size = length(matrix)

    matrix = rotate_counter(matrix |> Enum.map(&String.codepoints/1), [])

    {_, [{start, _} | tail]} =
      Enum.reduce_while(1..cycles, {matrix, []}, fn ix, {matrix, weights} ->
        {ctrl, {mem_ix, acc}} = with_cache({"cycle", matrix}, ix, fn -> cycle(matrix) end)

        {ctrl, {acc, [{mem_ix, rotate(acc) |> weight(rows_size)} | weights]}}
      end)

    pattern = Enum.reverse(tail) |> Enum.drop(start - 1) |> Enum.map(&elem(&1, 1))

    Enum.at(pattern, rem(cycles - start, length(pattern)))
  end

  defp weight(matrix, rows_size) do
    Enum.reduce(matrix, {rows_size, 0}, fn matrix, {ix, acc} ->
      {ix - 1, acc + Enum.count(matrix, &(&1 == "O")) * ix}
    end)
    |> elem(1)
  end

  defp cycle(rows) do
    Enum.reduce(1..4, rows, fn ix, matrix ->
      with_cache({"rotate", matrix}, ix, fn ->
        rotate(matrix)
        |> Enum.map(&Enum.join/1)
        |> tilt()
      end)
      |> elem(1)
      |> elem(1)
    end)
  end

  # rows = ["......", "......", ...]
  defp transpose(rows) do
    rows
    |> Enum.map(&String.codepoints/1)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp rotate([[] | _]), do: []

  defp rotate(matrix) do
    [
      matrix |> Enum.map(fn [h | _] -> h end) |> Enum.reverse()
      | rotate(matrix |> Enum.map(fn [_ | tail] -> tail end))
    ]
  end

  defp rotate_counter([[] | _], acc), do: acc

  defp rotate_counter(matrix, acc) do
    rotate_counter(
      matrix |> Enum.map(fn [_ | tail] -> tail end),
      [matrix |> Enum.map(fn [h | _] -> h end) | acc]
    )
  end

  defp with_cache(key, ix, fun) do
    cached = Process.get(key)

    if cached != nil do
      {:halt, cached}
    else
      res = {ix, fun.()}
      Process.put(key, res)
      {:cont, res}
    end
  end
end
