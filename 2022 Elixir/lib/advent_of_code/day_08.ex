# Matrixes will be easier probably... not sure how to easily access them in elixir...
# so just iterating left to right always while reversing / transposing the lists

defmodule AdventOfCode.Day08 do
  # Start with something like, where the boolean is "visibility"
  # [
  #   [{3, false}, {0, false}, {3, false}, {7, false}, {3, false}],
  #   [{2, false}, {5, false}, {5, false}, {1, false}, {2, false}],
  #   [{6, false}, {5, false}, {3, false}, {3, false}, {2, false}],
  #   [{3, false}, {3, false}, {5, false}, {4, false}, {9, false}],
  #   [{3, false}, {5, false}, {3, false}, {9, false}, {0, false}]
  # ]
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.graphemes(&1)
        |> Enum.map(fn c -> {String.to_integer(c), false} end))
    )
    # left to right
    |> Enum.map(&check_row/1)
    # right to left
    |> Enum.map(&check_row/1)
    |> transpose()
    # bottom to top
    |> Enum.map(&check_row/1)
    # top to bottom
    |> Enum.map(&check_row/1)
    |> List.flatten()
    |> Enum.filter(fn {_, b} -> b end)
    |> length()
  end

  # Just check left to right, result is reversed
  defp check_row(row) do
    {_, new_row} =
      row
      |> Enum.reduce({-1, []}, fn {val, visible}, {b, res} ->
        if val > b, do: {val, [{val, true} | res]}, else: {b, [{val, false || visible} | res]}
      end)

    new_row
  end

  defp transpose(rows) do
    rows
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  # The list represents number of trees visible in each direction
  # [
  #   [{3, []}, {0, []}, {3, []}, {7, []}, {3, []}],
  #   [{2, []}, {5, []}, {5, []}, {1, []}, {2, []}],
  #   [{6, []}, {5, []}, {3, []}, {3, []}, {2, []}],
  #   [{3, []}, {3, []}, {5, []}, {4, []}, {9, []}],
  #   [{3, []}, {5, []}, {3, []}, {9, []}, {0, []}]
  # ]
  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(String.graphemes(&1)
        |> Enum.map(fn c -> {String.to_integer(c), []} end))
    )
    |> Enum.map(&(calculate_row(&1) |> Enum.reverse()))
    |> Enum.map(&(calculate_row(&1) |> Enum.reverse()))
    |> transpose()
    |> Enum.map(&(calculate_row(&1) |> Enum.reverse()))
    |> Enum.map(&calculate_row(&1))
    |> List.flatten()
    |> Enum.map(fn {_, list} -> Enum.reduce(list, 1, fn v, acc -> v * acc end) end)
    |> Enum.max()
  end

  defp calculate_row([]), do: []

  defp calculate_row([_ | tail] = row) do
    [calculate_tree(row) | calculate_row(tail)]
  end

  defp calculate_tree([{tree, list} | _] = row) do
    count =
      row
      |> Enum.drop(1)
      |> Enum.take_while(fn {v, _} -> v < tree end)
      |> length()

    # Do nothing when it reaches the border... if there is a blocking tree add 1 to count it
    fix = if count + 1 < length(row), do: 1, else: 0

    {tree, [count + fix | list]}
  end
end
