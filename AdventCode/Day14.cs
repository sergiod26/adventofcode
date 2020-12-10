using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdventCode
{
    class Day14 : Day
    {
        public override int Number => 14;

        private readonly List<string[]> _instructions;
        private readonly Regex _regex = new Regex("(\\d+)");

        public Day14()
        {
            _instructions = Lines.Select(x => x.Split(" = ")).ToList();
        }

        public override double PartA()
        {
            var memory = new Dictionary<long, long>();
            long value0 = 0;
            long value1 = 0;


            foreach (var inst in _instructions)
            {
                if (inst[0] == "mask")
                {
                    var mask = inst[1];

                    var mask0 = mask.Replace('X', '1');
                    var mask1 = mask.Replace('X', '0');

                    value0 = Convert.ToInt64(mask0, 2);
                    value1 = Convert.ToInt64(mask1, 2);
                    continue;
                }


                var index = int.Parse(_regex.Match(inst[0]).Groups[1].Value);
                var result = long.Parse(inst[1]) & value0 | value1;

                memory[index] = result;
            }

            return memory.Values.Sum();
        }

        public override double PartB()
        {
            var memory = new Dictionary<long, long>();

            var masks = new List<(long, long)>();

            long value0 = 0;

            foreach (var inst in _instructions)
            {
                if (inst[0] == "mask")
                {
                    var mask0 = inst[1].Replace('X', '0');
                    value0 = Convert.ToInt64(mask0, 2);
                    masks = GetMasks(inst[1]);
                    continue;
                }


                var index = long.Parse(_regex.Match(inst[0]).Groups[1].Value) | value0;
                var value = long.Parse(inst[1]);


                foreach (var mask in masks)
                {
                    memory[index & mask.Item1 | mask.Item2] = value;
                }
            }

            return memory.Values.Sum();


            List<(long, long)> GetMasks(string mask)
            {
                var pendingMasks = new Stack<(string, string)>();
                pendingMasks.Push((mask.Replace("0", "1"), mask.Replace("1", "0")));

                var regex = new Regex("X");
                var masks = new List<(long, long)>();

                while (pendingMasks.Any())
                {
                    var current = pendingMasks.Pop();

                    if (!current.Item1.Contains("X"))
                    {
                        masks.Add((Convert.ToInt64(current.Item1, 2), Convert.ToInt64(current.Item2, 2)));
                        continue;
                    }

                    pendingMasks.Push((regex.Replace(current.Item1, "0", 1), regex.Replace(current.Item2, "0", 1)));
                    pendingMasks.Push((regex.Replace(current.Item1, "1", 1), regex.Replace(current.Item2, "1", 1)));

                }

                return masks;
            }
        }




    }
}
