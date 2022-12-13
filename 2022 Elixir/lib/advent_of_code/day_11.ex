# I should read better... collected a bunch of info, then realized the question was different
# anyway... part1 was not particulary difficult... just follow instructions
# part2 in the other hand... fuck that... I stole it and honestly have no idea why that works...
# some day I may look it up!! (this crap also needs refactor!)

defmodule AdventOfCode.Day11 do
  defp parse(args) do
    args
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn l ->
      [ix, items, op, test, iftrue, iffalse] = String.split(l, "\n", trim: true)

      ix = String.replace(ix, "Monkey ", "") |> String.replace(":", "") |> String.to_integer()

      items =
        String.replace(items, ~r/.*Starting items: /, "")
        |> String.split(", ")
        |> Enum.map(&String.to_integer(&1))

      [op, val] = String.replace(op, ~r/.*Operation: new = old /, "") |> String.split(" ")
      test = String.replace(test, ~r/.*Test: divisible by /, "") |> String.to_integer()
      iftrue = String.replace(iftrue, ~r/.*If true: throw to monkey /, "") |> String.to_integer()

      iffalse =
        String.replace(iffalse, ~r/.*If false: throw to monkey /, "") |> String.to_integer()

      %{ix: ix, items: items, op: {op, val}, test: {test, iftrue, iffalse}}
    end)
  end

  def part1(args) do
    all = args |> parse()

    items =
      all
      |> Enum.map(fn l -> l[:items] end)
      |> Enum.with_index()
      |> Enum.map(fn {v, ix} -> {ix, v} end)
      |> Map.new()

    monkey_count = length(all)

    {_, _, activity} =
      0..19
      |> Enum.reduce(
        {items, List.duplicate(0, monkey_count), List.duplicate(0, monkey_count)},
        fn _, {acc, totals, counts} ->
          {new_list, new_counts} = cycle(all, acc)

          updated_totals =
            Enum.zip_with(
              [Map.values(acc) |> Enum.map(&length/1), totals],
              fn [x, y] -> x + y end
            )

          {new_list, updated_totals, Enum.zip_with(counts, new_counts, fn x, y -> x + y end)}
        end
      )

    [a, b] =
      activity
      |> Enum.sort()
      |> Enum.take(-2)

    a * b
  end

  defp cycle(all, items, worry \\ 3) do
    all
    |> Enum.reduce({items, []}, fn %{ix: ix, op: op, test: {div, ift, iff}}, {acc, counts} ->
      tmp =
        acc[ix]
        |> Enum.map(fn x ->
          new_val = if(worry == 3, do: div(calc(x, op), 3), else: rem(calc(x, op), worry))
          next = if(rem(new_val, div) == 0, do: ift, else: iff)
          {new_val, next}
        end)

      # IO.inspect("#{ix} #{length(acc[ix])}")

      tmp =
        tmp
        |> Enum.reduce(acc, fn {new_val, monkey}, updated_list ->
          Map.update!(updated_list, monkey, fn _ -> updated_list[monkey] ++ [new_val] end)
        end)
        |> Map.update!(ix, fn _ -> [] end)

      {tmp, counts ++ [length(acc[ix])]}
    end)
  end

  defp calc(initial, {operator, value}) do
    value = if(value == "old", do: initial, else: String.to_integer(value))

    case operator do
      "*" -> initial * value
      "+" -> initial + value
    end
  end

  def part2(args) do
    all = args |> parse()

    items =
      all
      |> Enum.map(fn l -> l[:items] end)
      |> Enum.with_index()
      |> Enum.map(fn {v, ix} -> {ix, v} end)
      |> Map.new()

    monkey_count = length(all)

    product =
      Enum.map(all, fn m ->
        {x, _, _} = m.test
        x
      end)
      |> Enum.product()

    {_, _, activity} =
      0..9999
      |> Enum.reduce(
        {items, List.duplicate(0, monkey_count), List.duplicate(0, monkey_count)},
        fn _, {acc, totals, counts} ->
          {new_list, new_counts} = cycle(all, acc, product)

          updated_totals =
            Enum.zip_with(
              [Map.values(acc) |> Enum.map(&length/1), totals],
              fn [x, y] -> x + y end
            )

          {new_list, updated_totals, Enum.zip_with(counts, new_counts, fn x, y -> x + y end)}
        end
      )

    [a, b] =
      activity
      |> Enum.sort()
      |> Enum.take(-2)

    a * b
  end
end
