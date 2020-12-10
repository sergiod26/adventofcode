using System.Linq;

namespace AdventCode
{
    public class Day06 : Day
    {
        public override int Number => 6;

        public override double PartA()
        {
            var count = Input
                   .Replace("\n\n", "Ñ")
                   .Replace("\n", "")
                   .Split("Ñ")
                   .Select(x => x.Distinct().Count()).Sum();

            return count;
        }

        public override double PartB()
        {
            var answers = Input
                .Replace("\n\n", "Ñ")
                .Replace("\n", " ")
                .Split("Ñ")
                .Select(x => x.Split(" "))
                .ToList();

            var ret = 0;
            foreach (var line in answers)
            {
                var first = line.First();
                var count = first.Count(letter => line.All(x => x.Contains(letter.ToString())));
                ret += count;
            }

            return ret;
        }
    }
}
