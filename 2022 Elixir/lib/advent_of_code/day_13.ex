defmodule AdventOfCode.Day13 do
  def part1(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, "\n", trim: true)
      |> Enum.map(fn x ->
        {r, _} = Code.eval_string(x)
        r
      end)
    end)
    |> Enum.map(fn [v1, v2] -> compare(v1, v2) end)
    |> Enum.with_index()
    |> Enum.filter(fn {r, _} -> r == :lt end)
    |> Enum.map(fn {_, ix} -> ix + 1 end)
    |> Enum.sum()
  end

  def part2(args) do
    [{_, ix1}, {_, ix2}] =
      args
      |> String.split("\n", trim: true)
      |> Enum.map(fn x ->
        {r, _} = Code.eval_string(x)
        r
      end)
      |> Enum.concat([[[2]], [[6]]])
      |> bubblesort
      |> Enum.with_index()
      |> Enum.filter(fn {val, _} -> val == [[2]] || val == [[6]] end)

    (ix1 + 1) * (ix2 + 1)
  end

  defp compare(num1, num2) when is_integer(num1) and is_integer(num2) do
    cond do
      num1 == num2 -> :eq
      num1 < num2 -> :lt
      true -> :gt
    end
  end

  defp compare([], []), do: :eq
  defp compare([], list) when is_list(list), do: :lt
  defp compare(list, []) when is_list(list), do: :gt
  defp compare(num, list) when is_integer(num) and is_list(list), do: compare([num], list)
  defp compare(list, num) when is_integer(num) and is_list(list), do: compare(list, [num])

  defp compare([h1 | t1], [h2 | t2]) do
    res = compare(h1, h2)
    if res != :eq, do: res, else: compare(t1, t2)
  end

  # In C# you can do a custom comparer that returns -1, 0, or 1... was googling something similar but
  # didn't find it quickly enough... so instead behold bubblesort!
  defp bubblesort(list) do
    it = iterate(list)
    if it == list, do: it, else: bubblesort(it)
  end

  defp iterate([x, y | t]) do
    if compare(x, y) == :lt do
      [x | iterate([y | t])]
    else
      [y | iterate([x | t])]
    end
  end

  defp iterate(list), do: list
end
