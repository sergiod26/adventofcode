# Hardest part is to parse?
# - create N stacks (remember it starts at 1)
# - pop and push away?!

defmodule AdventOfCode.Day05 do
  defp parse(args) do
    [stacks, proc] =
      args
      |> String.split("\n\n", trim: true)

    stack_count =
      stacks
      |> String.split("\n", trim: true)
      |> Enum.take(-1)
      |> (fn [x] -> String.split(x, " ", trim: true) end).()
      |> length()

    stacks =
      stacks
      |> String.split("\n", trim: true)
      |> Enum.drop(-1)
      |> Enum.map(fn l ->
        Enum.chunk_every(String.graphemes(l), 4) |> Enum.map(fn x -> Enum.at(x, 1) end)
      end)

    max = (Enum.map(stacks, &length/1) |> Enum.max()) - 1

    stacks =
      Enum.map(0..max, fn y -> Enum.map(stacks, fn x -> Enum.at(x, y) end) end)
      |> Enum.map(fn x -> Enum.filter(x, fn y -> y != " " && !is_nil(y) end) end)

    stacks = [[] | stacks]

    proc =
      proc
      |> String.split("\n", trim: true)
      |> Stream.map(fn l ->
        [_, qt, _, from, _, to] = String.split(l, " ")
        {String.to_integer(qt), String.to_integer(from), String.to_integer(to)}
      end)

    {stacks, proc, stack_count}
  end

  def part1(args) do
    {stacks, proc, size} = parse(args)

    for(
      x <-
        Enum.reduce(proc, stacks, fn instruction, acc -> move(acc, instruction, size) end)
        |> Enum.drop(1),
      do: Enum.at(x, 0)
    )
    |> to_string()
  end

  defp move(stacks, {qt, from_ix, to_ix}, size) do
    from = Enum.at(stacks, from_ix)
    to = Enum.at(stacks, to_ix)

    {new_from, new_to} = {
      Enum.drop(from, qt),
      Enum.reduce(0..(qt - 1), to, fn x, acc -> [Enum.at(from, x) | acc] end)
    }

    Enum.map(0..size, fn ix ->
      cond do
        ix == from_ix -> new_from
        ix == to_ix -> new_to
        true -> Enum.at(stacks, ix)
      end
    end)
  end

  def part2(args) do
    {stacks, proc, size} = parse(args)

    for(
      x <-
        Enum.reduce(proc, stacks, fn instruction, acc -> move2(acc, instruction, size) end)
        |> Enum.drop(1),
      do: Enum.at(x, 0)
    )
    |> to_string()
  end

  defp move2(stacks, {qt, from_ix, to_ix}, size) do
    from = Enum.at(stacks, from_ix)
    to = Enum.at(stacks, to_ix)

    {new_from, new_to} = {
      Enum.drop(from, qt),
      Enum.take(from, qt) ++ to
    }

    Enum.map(0..size, fn ix ->
      cond do
        ix == from_ix -> new_from
        ix == to_ix -> new_to
        true -> Enum.at(stacks, ix)
      end
    end)
  end
end
