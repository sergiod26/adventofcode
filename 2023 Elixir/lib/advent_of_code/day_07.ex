defmodule AdventOfCode.Day07 do
  def part1(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [cards, bid] = String.split(l)

      cards = String.codepoints(cards)

      hand =
        cards
        |> Enum.group_by(fn k -> k end)
        |> Enum.map(fn {_, g} -> length(g) end)
        |> Enum.sort(:desc)
        |> hand()

      {cards, hand, String.to_integer(bid)}
    end)
    |> Enum.sort(&compare/2)
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, ix}, acc -> acc + bid * ix end)
  end

  def part2(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      [cards, bid] = String.split(l)

      cards = String.codepoints(cards)
      hand = cards |> Enum.group_by(fn k -> k end)
      jokers = length(Map.get(hand, "J", []))

      hand =
        hand
        |> Map.delete("J")
        |> Enum.map(fn {_, g} -> length(g) end)
        |> Enum.sort(:desc)
        |> add_jokers(jokers)
        |> hand()

      {cards, hand, String.to_integer(bid)}
    end)
    |> Enum.sort(&compare(&1, &2, -1))
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {{_, _, bid}, ix}, acc -> acc + bid * ix end)
  end

  defp compare({cards1, hand1, _}, {cards2, hand2, _}, part2 \\ 11) do
    if hand1 != hand2, do: hand1 < hand2, else: compare_cards(cards1, cards2, part2)
  end

  defp compare_cards([], [], _), do: true

  defp compare_cards([h1 | t1], [h2 | t2], part2),
    do:
      if(h1 != h2, do: to_num(h1, part2) < to_num(h2, part2), else: compare_cards(t1, t2, part2))

  defp hand([5]), do: 7
  defp hand([4, 1]), do: 6
  defp hand([3, 2]), do: 5
  defp hand([3, 1, 1]), do: 4
  defp hand([2, 2, 1]), do: 3
  defp hand([2, 1, 1, 1]), do: 2
  defp hand([1, 1, 1, 1, 1]), do: 1

  defp to_num("A", _), do: 14
  defp to_num("K", _), do: 13
  defp to_num("Q", _), do: 12
  defp to_num("J", part2), do: part2
  defp to_num("T", _), do: 10
  defp to_num(d, _), do: String.to_integer(d)

  def add_jokers([], add), do: [add]
  def add_jokers([j | tail], add), do: [j + add | tail]
end
