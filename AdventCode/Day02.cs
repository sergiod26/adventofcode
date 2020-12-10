using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day02 : Day
    {
        private readonly List<string[]> _lines;

        public Day02()
        {
            _lines = Lines.Select(x => x.Split(new[] { '-', ':', ' ' }, StringSplitOptions.RemoveEmptyEntries)).ToList();
        }

        public override int Number => 2;
        public override double PartA()
        {
            var total = 0;
            foreach (var line in _lines)
            {
                var reps = line[3].Count(x => x == line[2][0]);

                if (int.Parse(line[0]) <= reps && reps <= int.Parse(line[1]))
                {
                    total++;
                }
            }

            return total;
        }

        public override double PartB()
        {
            var total = 0;
            foreach (var line in _lines)
            {
                var pos1 = int.Parse(line[0]) - 1;
                var pos2 = int.Parse(line[1]) - 1;

                var valid = line[3][pos1] == line[2][0] ^ line[3][pos2] == line[2][0];

                if (valid)
                {
                    total++;
                }
            }

            return total;
        }
    }
}
