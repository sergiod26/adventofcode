defmodule AdventOfCode.Day25Test do
  use ExUnit.Case

  import AdventOfCode.Day25

  @input "jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr"

  test "part1" do
    result = part1(@input)
    assert result == 54
  end

  @tag :skip
  test "part2" do
    result = part2(@input)
    assert result
  end
end
