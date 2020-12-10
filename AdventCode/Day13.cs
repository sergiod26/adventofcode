using System.Data;
using System.Linq;

namespace AdventCode
{
    class Day13 : Day
    {
        private string[] timestaps;
        private long earliest;
        public override int Number => 13;

        public Day13()
        {
            earliest = long.Parse(Lines.First());
            timestaps = Lines[1].Split(',');
        }

        public override double PartA()
        {
            var qwe = timestaps.Where(x => x != "x")
                .Select(x =>
                {
                    var y = long.Parse(x);
                    var mod = earliest % y;
                    return (y, mod == 0 ? 0 : y - mod);

                })
                .OrderBy(x => x.Item2)//order is dumb, just need min
                .ToList();

            var abc = qwe.First();

            return abc.Item1 * abc.Item2;
        }

        public override double PartB()
        {
            var list = timestaps.Select((t, i) => (t, i)).Where(x => x.t != "x").Select(x => (t: long.Parse(x.t), x.i)).ToList();

            var jump = list[0].t;
            var index = 1;
            long k;
            for (k = list[0].t; index < list.Count; k += jump)
            {
                if ((k + list[index].i) % list[index].t == 0)
                {
                    jump = lcm(jump, list[index].t);
                    index++;
                }
            }

            return k - jump;


            long lcm(long a, long b)
            {
                long num1, num2;
                if (a > b)
                {
                    num1 = a; num2 = b;
                }
                else
                {
                    num1 = b; num2 = a;
                }

                for (long i = 1; i < num2; i++)
                {
                    long mult = num1 * i;
                    if (mult % num2 == 0)
                    {
                        return mult;
                    }
                }
                return num1 * num2;
            }
        }
    }
}
