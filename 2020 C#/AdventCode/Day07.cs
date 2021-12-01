using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdventCode
{
    class Day07 : Day
    {
        public override int Number => 7;

        public Day07()
        {
            _lines = Lines.Select(x => x.Split(" bags contain ")).ToList();
        }

        public override double PartA()
        {
            var result = new HashSet<string>();
            var toCheck = new List<string> { MyBag };

            while (toCheck.Any())
            {
                var bag = toCheck.First();
                toCheck.Remove(bag);

                var options = _lines.Where(x => x[1].Contains(bag)).ToList();


                foreach (var s in options.Select(x => x[0]).Where(y => !result.Contains(y)))
                {
                    result.Add(s);
                    toCheck.Add(s);
                }

            }


            return result.Count;
        }

        public override double PartB()
        {
            return Calculate(MyBag) - 1;


            int Calculate(string bag)
            {
                var vals = _lines.First(x => x[0] == bag)[1];

                if (vals.Contains("no other bags"))
                {
                    return 1;
                }

                var regex = new Regex("(\\d) (\\w+ \\w+).*");

                var bags = vals.Split(",");

                var total = 1;
                foreach (var b in bags)
                {
                    var tmp = regex.Match(b);
                    total += int.Parse(tmp.Groups[1].Value) * Calculate(tmp.Groups[2].Value);

                }

                return total;

            }
        }

        private readonly List<string[]> _lines;
        private const string MyBag = "shiny gold";
    }
}
