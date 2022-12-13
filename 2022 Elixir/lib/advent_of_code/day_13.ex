defmodule Packet do
  defstruct [:data]

  def compare(%Packet{data: d1}, %Packet{data: d2}), do: do_compare(d1, d2)

  defp do_compare(num1, num2) when is_integer(num1) and is_integer(num2) do
    cond do
      num1 == num2 -> :eq
      num1 < num2 -> :lt
      true -> :gt
    end
  end

  defp do_compare([], []), do: :eq
  defp do_compare([], list) when is_list(list), do: :lt
  defp do_compare(list, []) when is_list(list), do: :gt
  defp do_compare(num, list) when is_integer(num) and is_list(list), do: do_compare([num], list)
  defp do_compare(list, num) when is_integer(num) and is_list(list), do: do_compare(list, [num])

  defp do_compare([h1 | t1], [h2 | t2]) do
    res = do_compare(h1, h2)
    if res != :eq, do: res, else: do_compare(t1, t2)
  end
end

defmodule AdventOfCode.Day13 do
  def part1(args) do
    dbg(
      Packet.compare(
        %Packet{
          data: [
            [7],
            [5, [[3, 8, 9], [1], 5], [[7, 4], 6, [], 0], [1, 8, [1, 5, 9]]],
            [],
            [[[8, 1, 8, 8, 8], 5, 0, 6], 5, 5, 4]
          ]
        },
        %Packet{data: [[7, [[4, 6, 4, 2], [0]], []]]}
      )
    )

    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, "\n", trim: true)
      |> Enum.map(fn x ->
        {r, _} = Code.eval_string(x)
        %Packet{data: r}
      end)
    end)
    |> Enum.map(fn [v1, v2] -> Packet.compare(v1, v2) end)
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
        %Packet{data: r}
      end)
      |> Enum.concat([%Packet{data: [[2]]}, %Packet{data: [[6]]}])
      |> Enum.sort(Packet)
      |> Enum.with_index()
      |> Enum.filter(fn {%Packet{data: val}, _} -> val == [[2]] || val == [[6]] end)

    (ix1 + 1) * (ix2 + 1)
  end
end
