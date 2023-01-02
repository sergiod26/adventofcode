defmodule AdventOfCode.Day19 do
  def part1(args) do
    blueprint = %{
      ore: %{ore: 4},
      clay: %{ore: 2},
      obsidian: %{ore: 3, clay: 8},
      geode: %{ore: 3, obsidian: 12}
    }

    max_ore =
      Enum.max([
        blueprint[:ore][:ore],
        blueprint[:clay][:ore],
        blueprint[:obsidian][:ore],
        blueprint[:geode][:ore]
      ])

    max_clay = blueprint[:obsidian][:clay]

    max_obsidian = blueprint[:geode][:obsidian]

    robots = %{ore: 1, clay: 0, obsidian: 0, geode: 0}
    resources = %{ore: 0, clay: 0, obsidian: 0, geode: 0}

    iterate(blueprint, [{robots, resources}], max_ore, max_clay, max_obsidian, 0) |> dbg
  end

  defp iterate(_, list, _, _, _, 23), do: list

  defp iterate(blueprint, list, max_ore, max_clay, max_obsidian, it) do
    iterate(
      blueprint,
      Enum.flat_map(list, fn {robots, resources} ->
        get_options(blueprint, robots, resources, max_ore, max_clay, max_obsidian)
      end),
      max_ore,
      max_clay,
      max_obsidian,
      it + 1
    )
  end

  defp get_options(blueprint, robots, resources, max_ore, max_clay, max_obsidian) do
    [
      # build ore robot
      if robots[:ore] < max_ore &&
           blueprint[:ore][:ore] <= resources[:ore] do
        {Map.update!(robots, :ore, fn v -> v + 1 end),
         Map.update!(resources, :ore, fn v -> v - blueprint[:ore][:ore] end)
         |> Map.merge(robots, fn _, v1, v2 -> v1 + v2 end)}
      end,

      # build clay robot
      if robots[:clay] < max_clay &&
           blueprint[:clay][:ore] <= resources[:ore] do
        {Map.update!(robots, :clay, fn v -> v + 1 end),
         Map.update!(resources, :ore, fn v -> v - blueprint[:clay][:ore] end)
         |> Map.merge(robots, fn _, v1, v2 -> v1 + v2 end)}
      end,

      # build r_obsidian
      if robots[:obsidian] < max_obsidian &&
           blueprint[:obsidian][:ore] <= resources[:ore] &&
           blueprint[:obsidian][:clay] <= resources[:clay] do
        {Map.update!(robots, :obsidian, fn v -> v + 1 end),
         Map.update!(resources, :ore, fn v -> v - blueprint[:obsidian][:ore] end)
         |> Map.update!(:clay, fn v -> v - blueprint[:obsidian][:clay] end)
         |> Map.merge(robots, fn _, v1, v2 -> v1 + v2 end)}
      end,

      # build geode robot
      if blueprint[:geode][:obsidian] <= resources[:clay] do
        {Map.update!(robots, :geode, fn v -> v + 1 end),
         Map.update!(resources, :ore, fn v -> v - blueprint[:geode][:ore] end)
         |> Map.update!(:obsidian, fn v -> v - blueprint[:geode][:obsidian] end)
         |> Map.merge(robots, fn _, v1, v2 -> v1 + v2 end)}
      end,
      # dont build anything
      {robots, Map.merge(resources, robots, fn _, v1, v2 -> v1 + v2 end)}
    ]
    |> Enum.filter(& &1)
  end

  def part2(args) do
  end
end
