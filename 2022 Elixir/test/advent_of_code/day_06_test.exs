defmodule AdventOfCode.Day06Test do
  use ExUnit.Case

  import AdventOfCode.Day06

  test "part1" do
    assert part1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
    assert part1("nppdvjthqldpwncqszvftbrmjlhg") == 6
    assert part1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
    assert part1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
  end

  test "part2" do
    assert part2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
    assert part2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
    assert part2("nppdvjthqldpwncqszvftbrmjlhg") == 23
    assert part2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
    assert part2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
  end
end
