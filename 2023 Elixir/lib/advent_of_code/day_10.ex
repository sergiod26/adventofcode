defmodule AdventOfCode.Day10 do
  require Integer

  def part1(args) do
    matrix = args |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)

    map =
      for {row, row_ix} <- Enum.with_index(matrix) do
        for({val, col_ix} <- Enum.with_index(row)) do
          {val, row_ix, col_ix}
        end
      end
      |> List.flatten()
      |> Enum.reduce(%{}, fn {val, row, col}, acc ->
        if val != "." do
          Map.put(acc, {row, col}, val)
        else
          acc
        end
      end)

    [{{r, c}, _}] = map |> Enum.filter(fn {_, v} -> v == "S" end)

    right = map[{r, c + 1}]
    left = map[{r, c - 1}]
    up = map[{r - 1, c}]
    # down = map[{r + 1, c}]

    {coord, dir} =
      cond do
        right == "-" || right == "J" || right == "7" ->
          {{r, c + 1}, :right}

        left == "-" || left == "F" || left == "L" ->
          {{r, c - 1}, :left}

        up == "|" || up == "F" || up == "7" ->
          {{r - 1, c}, :up}

        true ->
          {{r + 1, c}, :down}
      end

    result =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(
        {coord, dir},
        fn ix, {coord, dir} ->
          pipe = map[coord]
          if pipe == "S", do: {:halt, ix}, else: {:cont, move(coord, pipe, dir)}
        end
      )

    div(result, 2)
  end

  defp move({row, col}, "|", :down), do: {{row + 1, col}, :down}
  defp move({row, col}, "|", :up), do: {{row - 1, col}, :up}

  defp move({row, col}, "-", :right), do: {{row, col + 1}, :right}
  defp move({row, col}, "-", :left), do: {{row, col - 1}, :left}

  defp move({row, col}, "F", :up), do: {{row, col + 1}, :right}
  defp move({row, col}, "F", :left), do: {{row + 1, col}, :down}

  defp move({row, col}, "7", :right), do: {{row + 1, col}, :down}
  defp move({row, col}, "7", :up), do: {{row, col - 1}, :left}

  defp move({row, col}, "J", :down), do: {{row, col - 1}, :left}
  defp move({row, col}, "J", :right), do: {{row - 1, col}, :up}

  defp move({row, col}, "L", :down), do: {{row, col + 1}, :right}
  defp move({row, col}, "L", :left), do: {{row - 1, col}, :up}

  def part2(args) do
    matrix = args |> String.split("\n", trim: true) |> Enum.map(&String.codepoints/1)

    map =
      for {row, row_ix} <- Enum.with_index(matrix) do
        for({val, col_ix} <- Enum.with_index(row)) do
          {val, row_ix, col_ix}
        end
      end
      |> List.flatten()
      |> Enum.reduce(%{}, fn {val, row, col}, acc ->
        if val != "." do
          Map.put(acc, {row, col}, val)
        else
          acc
        end
      end)

    [{{r, c}, _}] = map |> Enum.filter(fn {_, v} -> v == "S" end)

    right = map[{r, c + 1}]
    left = map[{r, c - 1}]
    up = map[{r - 1, c}]
    down = map[{r + 1, c}]

    has_right = right == "-" || right == "J" || right == "7"
    has_left = left == "-" || left == "F" || left == "L"
    has_up = up == "|" || up == "F" || up == "7"
    has_down = down == "|" || down == "L" || down == "J"

    {coord, dir} =
      cond do
        has_right ->
          {{r, c + 1}, :right}

        has_left ->
          {{r, c - 1}, :left}

        has_up ->
          {{r - 1, c}, :up}

        true ->
          {{r + 1, c}, :down}
      end

    result =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while(
        {{coord, dir}, []},
        fn _, {{coord, dir}, acc} ->
          pipe = map[coord]

          if pipe == "S",
            do: {:halt, [{coord, pipe_type(has_up, has_right, has_down, has_left)} | acc]},
            else: {:cont, {move(coord, pipe, dir), [{coord, pipe} | acc]}}
        end
      )
      |> Map.new()

    {{min_x, _}, {max_x, _}} = Map.keys(result) |> Enum.min_max_by(fn {x, _} -> x end)
    {{_, min_y}, {_, max_y}} = Map.keys(result) |> Enum.min_max_by(fn {_, y} -> y end)

    {{min_x, max_x}, {min_y, max_y}}

    horizontal =
      0..max_x
      |> Enum.flat_map(fn row ->
        {_, coords} =
          Enum.reduce(0..max_y, {0, []}, fn col, {cruces, acc} ->
            pipe = Map.get(result, {row, col}, ".")

            cond do
              pipe == "|" || pipe == "L" || pipe == "J" ->
                {cruces + 1, acc}

              pipe == "." && Integer.is_odd(cruces) ->
                {cruces, [{row, col} | acc]}

              true ->
                {cruces, acc}
            end
          end)

        coords
      end)

    0..max_y
    |> Enum.flat_map(fn col ->
      {_, coords} =
        Enum.reduce(0..max_x, {0, horizontal}, fn row, {cruces, acc} ->
          pipe = Map.get(result, {row, col}, ".")

          cond do
            pipe == "-" || pipe == "J" || pipe == "7" ->
              {cruces + 1, acc}

            pipe == "." && Integer.is_odd(cruces) ->
              {cruces, [{row, col} | acc]}

            true ->
              {cruces, acc}
          end
        end)

      coords
    end)
    |> Enum.uniq()
    |> length()
  end

  # up right down left
  defp pipe_type(true, true, false, false), do: "L"
  defp pipe_type(false, true, true, false), do: "F"
  defp pipe_type(true, false, false, true), do: "J"
  defp pipe_type(false, false, true, true), do: "7"
  defp pipe_type(true, false, true, false), do: "|"
  defp pipe_type(false, true, false, true), do: "-"
end
