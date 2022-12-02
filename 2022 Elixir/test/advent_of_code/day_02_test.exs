defmodule AdventOfCode.Day02Test do
  use ExUnit.Case

  import AdventOfCode.Day02

  test "part1" do
    input = "A Y\nB X\nC Z"
    result = part1(input)

    assert result == 15
  end

  test "part2" do
    input = "A Y\nB X\nC Z"
    result = part2(input)

    assert result == 12
  end
end
