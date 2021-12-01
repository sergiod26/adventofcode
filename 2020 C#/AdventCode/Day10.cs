using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day10 : Day
    {
        private readonly List<int> _adapters;


        public Day10()
        {
            _adapters = Lines.Select(int.Parse).OrderBy(x => x).ToList();
        }

        public override int Number => 10;

        public override double PartA()
        {
            var jolts = new double[4];
            jolts[_adapters[0]]++;
            jolts[3]++;

            for (var i = 1; i < _adapters.Count; i++)
            {
                jolts[_adapters[i] - _adapters[i - 1]]++;
            }

            return jolts[1] * jolts[3];
        }

        public override double PartB()
        {
            var adapters = _adapters.Prepend(0).ToList();
            var tmp = new double[adapters.Count];
            tmp[0] = 1;

            var size = adapters.Count;

            for (var i = 0; i < size; i++)
            {
                if (i + 1 < size && adapters[i + 1] - 3 <= adapters[i])
                {
                    tmp[i + 1] += tmp[i];
                }
                if (i + 2 < size && adapters[i + 2] - 3 <= adapters[i])
                {
                    tmp[i + 2] += tmp[i];
                }
                if (i + 3 < size && adapters[i + 3] - 3 <= adapters[i])
                {
                    tmp[i + 3] += tmp[i];
                }
            }


            var test = 12089663946752 == tmp[^1];

            return tmp[^1];
        }
    }
}
