using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day03 : Day
    {
        private readonly List<List<char>> _lines;
        public override int Number => 3;
        public override double PartA()
        {
            return Calc(3, 1);
        }

        public Day03()
        {
            _lines = Lines.Select(x => x.Select(y => y).ToList()).ToList();
        }

        public override double PartB()
        {
            var slopes = new[]
            {
                new {right = 1, down = 1},
                new {right = 3, down = 1},
                new {right = 5, down = 1},
                new {right = 7, down = 1},
                new {right = 1, down = 2}
            };

            return slopes.Aggregate(1.0, (current, pair) => current * Calc(pair.right, pair.down));
        }

        int Calc(int right, int down)
        {
            var pos = 0;
            var tmp = 0;
            int width = _lines[0].Count;

            for (var row = 0; row < _lines.Count; row += down)
            {
                if (_lines[row][pos] == '#')
                    tmp++;

                pos = (pos + right) % (width);
            }


            return tmp;
        }
    }
}
