using System;
using System.Linq;

namespace AdventCode
{
    class Day23 : Day
    {
        public override int Number => 23;
        public override double PartA()
        {

            var list = Input.Select(x => x - 48).ToList();

            for (var i = 0; i < 100; i++)
            {
                var pick = list.Skip(1).Take(3).ToList();
                var reminder = list.Except(pick).ToList();

                var smallerThanCurrent = reminder.Where(x => x < list.FirstOrDefault()).ToList();

                var next = smallerThanCurrent.Any() ? smallerThanCurrent.Max() : reminder.Max();

                reminder.InsertRange(reminder.IndexOf(next) + 1, pick);

                list = reminder.Skip(1).ToList().Concat(reminder.Take(1)).ToList();

            }

            var l1 = list.SkipWhile(x => x != 1).ToList();
            var l2 = list.TakeWhile(x => x != 1).ToList();

            Console.WriteLine("\tPart A: " + string.Join("", l1.Concat(l2).Skip(1)));

            return 0;
        }

        public override double PartB()
        {
            var original = Input.Select(x => x - 48).ToList();
            var min = original.Min();
            var max = original.Max();
            var size = original.Count;

            original.AddRange(Enumerable.Range(max + 1, 1_000_000 - size));
            size = original.Count;

            max = original.Max();

            var array = new int[max + 1];

            for (int i = 0; i < size - 1; i++)
            {
                array[original[i]] = original[i + 1];
            }


            var current = original.First();
            array[original[size - 1]] = current;

            for (var i = 0; i < 10_000_000; i++)
            {
                var c1 = array[current];
                var c2 = array[c1];
                var c3 = array[c2];
                var moveTo = current - 1;

                while (moveTo < min || moveTo == c1 || moveTo == c2 || moveTo == c3 || array[moveTo] == 0)
                {
                    moveTo--;

                    if (moveTo < min)
                    {
                        moveTo = max;
                    }
                }


                array[current] = array[c3];
                array[c3] = array[moveTo];
                array[moveTo] = c1;


                current = array[current];
            }

            var cup1 = array[1];
            var cup2 = array[cup1];

            return (long)cup1 * cup2;
        }
    }
}
