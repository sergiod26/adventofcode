using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    public class Day05 : Day
    {
        public override int Number => 5;
        private readonly IEnumerable<int> _passes;

        public Day05()
        {
            _passes = Lines.Select(str => GetSeat(str.Substring(0, 7), str.Substring(7)));
        }

        public override double PartA()
        {
            return _passes.Max();
        }

        public override double PartB()
        {
            var result = _passes.OrderBy(x => x).ToList();

            for (var i = 1; i < result.Count; i++)
            {
                if (result[i] + 1 != result[i + 1])
                    return result[i] + 1;
            }

            return -1;
        }

        private int GetSeat(string rowStr, string colStr)
        {
            var row = Convert.ToInt32(rowStr.Replace("F", "0").Replace("B", "1"), 2);
            var col = Convert.ToInt32(colStr.Replace("L", "0").Replace("R", "1"), 2);

            return row * 8 + col;
        }
    }
}
