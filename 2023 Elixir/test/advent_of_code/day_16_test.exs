defmodule AdventOfCode.Day16Test do
  use ExUnit.Case

  import AdventOfCode.Day16

  test "part1" do
    input = ".|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|...."

    result = part1(input)

    assert result == 46
  end

  test "part2" do
    input = ".|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|...."
    result = part2(input)

    assert result == 51
  end
end
