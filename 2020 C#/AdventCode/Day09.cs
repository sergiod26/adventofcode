using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day09 : Day
    {
        private readonly List<double> _lines;
        public override int Number => 9;


        public Day09()
        {
            _lines = Lines.Select(double.Parse).ToList();
        }
        public override double PartA()
        {
            var preamble = 25;

            for (var i = preamble; i < _lines.Count; i++)
            {
                var match = false;
                for (var j = i - preamble; j < i; j++)
                {
                    for (var z = j + 1; z < i; z++)
                    {
                        if (_lines[j] + _lines[z] == _lines[i])
                        {
                            match = true;
                            break;
                        }
                    }

                    if (match)
                    {
                        break;
                    }
                }

                if (!match)
                {
                    return _lines[i];
                }
            }

            return -1;
        }
        public override double PartB()
        {
            var expected = PartA();

            for (var i = 0; i < _lines.Count; i++)
            {
                var acc = _lines[i];
                for (var j = i + 1; j < _lines.Count; j++)
                {
                    acc += _lines[j];
                    if (acc == expected)
                    {
                        var subList = _lines.Skip(i).Take(j - i + 1).ToList();
                        return subList.Min() + subList.Max();
                    }

                    if (acc > expected)
                    {
                        break;
                    }

                }
            }


            return -1;
        }
    }
}
