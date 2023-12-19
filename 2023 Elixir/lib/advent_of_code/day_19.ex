defmodule AdventOfCode.Day19 do
  def part1(args) do
    args
    |> String.trim()
    |> String.split("\n\n", trim: true)
    |> tap(fn x -> dbg(length(x)) end)
    |> then(fn [workflows, ratings] ->
      workflows =
        String.split(workflows, "\n")
        |> Enum.map(fn workflow ->
          Regex.scan(~r/([^{]+){(.+)}/, workflow, capture: :all_but_first)
          |> then(fn [[name, str_rules]] ->
            rules =
              String.split(str_rules, ",")
              |> Enum.map(fn str_rule -> rule(String.split(str_rule, ":")) end)

            {name, rules}
          end)
        end)
        |> Map.new()

      ratings =
        String.split(ratings, "\n")
        |> Enum.map(fn rating ->
          String.replace(rating, ["{", "}"], "")
          |> String.split(",")
          |> Enum.map(fn rating ->
            [cat, val] = String.split(rating, "=")
            {cat, String.to_integer(val)}
          end)
          |> Map.new()
        end)

      {workflows, ratings}
    end)
    |> then(fn {workflows, ratings} ->
      Enum.filter(ratings, fn rating -> solve(workflows, rating, "in") end)
      |> Enum.flat_map(fn m -> Map.values(m) end)
      |> Enum.sum()
    end)
  end

  defp solve(_, _, "A"), do: true
  defp solve(_, _, "R"), do: false

  defp solve(workflows, rating, label) do
    solve(workflows, rating, apply_rule(workflows[label], rating))
  end

  defp apply_rule(workflow, rating) do
    Enum.reduce_while(workflow, nil, fn {label, foo}, _ ->
      next = foo.(rating[label])

      if is_nil(next), do: {:cont, nil}, else: {:halt, next}
    end)
  end

  defp rule([condition, label]) do
    [[cat, sign, rating]] = Regex.scan(~r/(.)([<>])(\d+)/, condition, capture: :all_but_first)

    comp =
      if sign == "<",
        do: fn x -> if x < String.to_integer(rating), do: label end,
        else: fn x -> if x > String.to_integer(rating), do: label end

    {cat, comp}
  end

  defp rule([label]), do: {nil, fn _ -> label end}

  def part2(_args) do
  end
end
