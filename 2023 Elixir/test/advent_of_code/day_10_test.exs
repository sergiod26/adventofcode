defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10

  #   test "part1" do
  #     input = "..F7.
  # .FJ|.
  # SJ.L7
  # |F--J
  # LJ..."
  #     result = part1(input)

  #     assert result == 8
  #   end

  #   test "part2" do
  #     input = "...........
  # .S-------7.
  # .|F-----7|.
  # .||.....||.
  # .||.....||.
  # .|L-7.F-J|.
  # .|..|.|..|.
  # .L--J.L--J.
  # ..........."
  #     result = part2(input)

  #     assert result == 4
  #   end

  #   test "part2.2" do
  #     input = ".F----7F7F7F7F-7....
  # .|F--7||||||||FJ....
  # .||.FJ||||||||L7....
  # FJL7L7LJLJ||LJ.L-7..
  # L--J.L7...LJS7F-7L7.
  # ....F-J..F7FJ|L7L7L7
  # ....L7.F7||L7|.L7L7|
  # .....|FJLJ|FJ|F7|.LJ
  # ....FJL-7.||.||||...
  # ....L---J.LJ.LJLJ..."
  #     result = part2(input)

  #     assert result == 8
  #   end

  test "part2.3" do
    input = "FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L"
    result = part2(input)

    assert result == 10
  end
end
