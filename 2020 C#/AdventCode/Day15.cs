using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day15 : Day
    {
        public override int Number => 15;
        private readonly List<(int, int)> _numbers;

        public Day15()
        {
            _numbers = Input
                .Split(new[] { ',', ' ' }, StringSplitOptions.RemoveEmptyEntries)
                .Select((n, ix) => (int.Parse(n), ix)).ToList();
        }

        public override double PartA()
        {
            return CalculateNumber(2020);
        }

        public override double PartB()
        {
            return CalculateNumber(30000000);
        }


        private int CalculateNumber(long th)
        {
            var dict = _numbers.ToDictionary(n => n.Item1, n => n.Item2);
            var next = 0;

            for (var i = dict.Count; i < th - 1; i++)
            {
                if (dict.ContainsKey(next))
                {
                    var tmpNext = next;
                    next = i - dict[next];
                    dict[tmpNext] = i;
                }
                else
                {
                    dict[next] = i;
                    next = 0;
                }
            }

            return next;
        }
    }
}
