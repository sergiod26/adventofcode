defmodule AdventOfCode.Day03 do
  def part1(args) do
    [digits, symbols] =
      args
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {l, ix} ->
        [
          # scan for all digits map to {row, col, number of digits, number}
          Regex.scan(~r/\d+/, l, return: :index)
          |> List.flatten()
          |> Enum.map(fn {pos, len} -> {ix, pos, len, String.slice(l, pos, len)} end),

          # scan for symbols, map to {row, col}
          Regex.scan(~r/[^\d\.]/, l, return: :index)
          |> List.flatten()
          |> Enum.map(fn {pos, _always_1} -> {ix, pos} end)
        ]
      end)
      |> Enum.zip()
      # have faith... this results in 2 lists of tuples
      |> Enum.map(fn x -> List.flatten(x |> Tuple.to_list()) end)

    digits
    # there has to be a better way to do intersection
    |> Enum.filter(fn x -> Enum.any?(symbols -- symbols -- neighbors(x)) end)
    |> Enum.reduce(0, fn {_, _, _, num}, acc -> String.to_integer(num) + acc end)
  end

  defp neighbors({x, y, len, _}) do
    # yeap... all of them... even non existing out of bounds
    for row <- (x - 1)..(x + 1), col <- (y - 1)..(y + len), do: {row, col}
  end

  def part2(args) do
    [digits, symbols] =
      args
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {l, ix} ->
        [
          Regex.scan(~r/\d+/, l, return: :index)
          |> List.flatten()
          |> Enum.map(fn {pos, len} -> {ix, pos, len, String.slice(l, pos, len)} end),

          # only * this time
          Regex.scan(~r/\*/, l, return: :index)
          |> List.flatten()
          |> Enum.map(fn {pos, _} -> {ix, pos} end)
        ]
      end)
      |> Enum.zip()
      |> Enum.map(fn x -> List.flatten(x |> Tuple.to_list()) end)

    digits
    # get all the symbols adjacent to a number
    |> Enum.map(fn x ->
      tmp = symbols -- symbols -- neighbors(x)

      if Enum.any?(tmp) do
        # ugly assumption but apparently it worked with my dataset,
        # if more than one symbol is adjacent to a number it will probably break
        {x, Enum.at(tmp, 0)}
      else
        nil
      end
    end)
    |> Enum.filter(fn x -> x end)
    # group by symbol coords
    |> Enum.group_by(fn {_, sym} -> sym end, fn {num, _} -> num end)
    # if the symbol coord has 2 number adjacent
    |> Enum.filter(fn {_, nums} -> length(nums) == 2 end)
    |> Enum.map(fn {_, [{_, _, _, num1}, {_, _, _, num2}]} ->
      String.to_integer(num1) * String.to_integer(num2)
    end)
    |> Enum.sum()
  end
end
