using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day01 : Day
    {
        private readonly List<int> _lines;

        public Day01()
        {
            _lines = Lines.Select(int.Parse).ToList();
        }

        public override int Number => 1;
        public override double PartA()
        {
            var size = _lines.Count;

            for (var i = 0; i < size - 1; i++)
            {
                for (var j = i + 1; j < size; j++)
                {
                    if (_lines[i] + _lines[j] == 2020)
                    {
                        return _lines[i] * _lines[j];
                    }
                }

            }

            return -1;
        }

        public override double PartB()
        {
            var size = _lines.Count;

            for (var i = 0; i < size - 2; i++)
            {
                for (var j = i + 1; j < size - 1; j++)
                {
                    for (var k = j + 1; k < size; k++)
                    {
                        if (_lines[i] + _lines[j] + _lines[k] == 2020)
                        {
                            return _lines[i] * _lines[j] * _lines[k];
                        }
                    }

                }
            }

            return -1;
        }
    }
}
