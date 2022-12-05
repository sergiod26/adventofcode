# Hardest part is to parse?
# - create N stacks (remember it starts at 1)
# - pop and push away?!

defmodule AdventOfCode.Day05 do
  defp parse(args) do
    [stacks, proc] =
      args
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    # Get the number of stacks by counting the numbers
    stack_count =
      stacks
      |> Enum.at(-1)
      |> String.split(" ", trim: true)
      |> length()

    stacks =
      stacks
      # Ignore the row of numbers
      |> Enum.drop(-1)
      # Convert to a list of letters
      |> Enum.map(&String.graphemes(&1))
      # Group by 4 letters (cuz [#] plus space), and take only the second one (index 1)
      |> Enum.map(&(Enum.chunk_every(&1, 4) |> Enum.map(fn x -> Enum.at(x, 1) end)))
      |> dbg

    # Get the longest list size, to use it in the homemade "zip"
    max = (Enum.map(stacks, &length/1) |> Enum.max()) - 1

    # I want a Enum.zip but that keeps going until the largest list is empty
    stacks =
      Enum.map(0..max, fn y -> Enum.map(stacks, &Enum.at(&1, y)) end)
      |> Enum.map(&Enum.filter(&1, fn y -> y != " " && !is_nil(y) end))

    # adding an empty set cuz WHO TF starts counting stacks on 1???
    stacks = [[] | stacks]

    proc =
      proc
      |> Stream.map(fn l ->
        # Take only numbers from "move 1 from 2 to 1"
        [_, qt, _, from, _, to] = String.split(l, " ")
        {String.to_integer(qt), String.to_integer(from), String.to_integer(to)}
      end)

    {stacks, proc, stack_count}
  end

  def part1(args) do
    {stacks, proc, size} = parse(args)

    Enum.reduce(proc, stacks, fn instruction, acc -> move(acc, instruction, size, :part1) end)
    # remember the extra []? kill it
    |> Enum.drop(1)
    # just take the top crate
    |> Enum.map(&Enum.at(&1, 0))
    |> to_string()
  end

  def part2(args) do
    {stacks, proc, size} = parse(args)

    Enum.reduce(proc, stacks, fn instruction, acc -> move(acc, instruction, size, :part2) end)
    |> Enum.drop(1)
    |> Enum.map(&Enum.at(&1, 0))
    |> to_string()
  end

  defp move(stacks, {qt, from_ix, to_ix}, size, part) do
    from = Enum.at(stacks, from_ix)
    to = Enum.at(stacks, to_ix)

    {new_from, new_to} = {
      Enum.drop(from, qt),
      case part do
        # move crates one by one
        :part1 -> Enum.reduce(0..(qt - 1), to, &[Enum.at(from, &1) | &2])
        # just take them!
        _ -> Enum.take(from, qt) ++ to
      end
    }

    Enum.map(0..size, fn
      ^from_ix -> new_from
      ^to_ix -> new_to
      ix -> Enum.at(stacks, ix)
    end)
  end
end
