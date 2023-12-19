defmodule AdventOfCode.Day16 do
  def part1(args) do
    {matrix, size_rows, size_cols} = input(args)
    solve(matrix, {{0, 0}, :right}, size_rows, size_cols)
  end

  def part2(args) do
    {matrix, size_rows, size_cols} = input(args)

    (for(r <- 0..(size_rows - 1), do: {{r, 0}, :right}) ++
       for(r <- 0..(size_rows - 1), do: {{r, size_cols - 1}, :left}) ++
       for(c <- 0..(size_cols - 1), do: {{0, c}, :down}) ++
       for(c <- 0..(size_cols - 1), do: {{size_rows - 1, c}, :up}))
    |> Enum.map(fn start -> solve(matrix, start, size_rows, size_cols) end)
    |> Enum.max()
  end

  defp input(args) do
    matrix =
      String.split(args, "\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {line, row} ->
        String.codepoints(line)
        |> Enum.with_index()
        |> Enum.map(fn {val, col} -> {{row, col}, val} end)
      end)

    size_rows = length(matrix)
    size_cols = length(Enum.at(matrix, 0))

    {matrix, size_rows, size_cols}
  end

  defp solve(matrix, start, size_rows, size_cols) do
    matrix
    |> List.flatten()
    |> Map.new()
    |> move(start, %{}, size_rows, size_cols)
    |> Map.keys()
    |> Enum.map(fn {coord, _} -> {coord, "#"} end)
    |> Map.new()
    |> Map.keys()
    |> Enum.count()
  end

  defp move(map, {{r, c}, _} = key, energized, size_rows, size_cols) do
    if Map.has_key?(energized, key) || r < 0 || r >= size_rows || c < 0 || c >= size_cols do
      energized
    else
      element = Map.get(map, {r, c})

      Enum.reduce(next(key, element), energized, fn m, acc ->
        move(map, m, Map.put(acc, key, "#"), size_rows, size_cols)
      end)
    end
  end

  defp next({{r, c}, :right}, "."), do: [{{r, c + 1}, :right}]
  defp next({{r, c}, :left}, "."), do: [{{r, c - 1}, :left}]
  defp next({{r, c}, :up}, "."), do: [{{r - 1, c}, :up}]
  defp next({{r, c}, :down}, "."), do: [{{r + 1, c}, :down}]

  defp next({{r, c}, :up}, "|"), do: [{{r - 1, c}, :up}]
  defp next({{r, c}, :down}, "|"), do: [{{r + 1, c}, :down}]
  defp next({{r, c}, _}, "|"), do: [{{r - 1, c}, :up}, {{r + 1, c}, :down}]

  defp next({{r, c}, :right}, "-"), do: [{{r, c + 1}, :right}]
  defp next({{r, c}, :left}, "-"), do: [{{r, c - 1}, :left}]
  defp next({{r, c}, _}, "-"), do: [{{r, c - 1}, :left}, {{r, c + 1}, :right}]

  defp next({{r, c}, :right}, "/"), do: [{{r - 1, c}, :up}]
  defp next({{r, c}, :left}, "/"), do: [{{r + 1, c}, :down}]
  defp next({{r, c}, :up}, "/"), do: [{{r, c + 1}, :right}]
  defp next({{r, c}, :down}, "/"), do: [{{r, c - 1}, :left}]

  defp next({{r, c}, :right}, "\\"), do: [{{r + 1, c}, :down}]
  defp next({{r, c}, :left}, "\\"), do: [{{r - 1, c}, :up}]
  defp next({{r, c}, :up}, "\\"), do: [{{r, c - 1}, :left}]
  defp next({{r, c}, :down}, "\\"), do: [{{r, c + 1}, :right}]
end
