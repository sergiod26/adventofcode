using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day12 : Day
    {
        public override int Number => 12;
        private readonly List<(char, int)> _instructions;

        public Day12()
        {
            _instructions = Lines.Select(x => (x[0], int.Parse(x.Substring(1)))).ToList();
        }

        public override double PartA()
        {
            var current = 0;

            var direction = new[] { 'E', 'S', 'W', 'N' };
            var movements = new Dictionary<char, int> { { 'E', 0 }, { 'S', 0 }, { 'W', 0 }, { 'N', 0 } };

            foreach (var i in _instructions)
            {
                switch (i.Item1)
                {
                    case 'L':
                        current = Left(i.Item2);
                        break;
                    case 'R':
                        current = Right(i.Item2);
                        break;
                    case 'F':
                        movements[direction[current]] += i.Item2;
                        break;
                    default:
                        movements[i.Item1] += i.Item2;
                        break;
                }
            }

            var result = Math.Abs(movements['N'] - movements['S']) + Math.Abs(movements['E'] - movements['W']);

            return result;

            int Left(int degrees)
            {
                return degrees == 90 ? Right(270) : degrees == 180 ? Right(180) : Right(90);
            }

            int Right(int degrees)
            {
                degrees = degrees / 90;
                return (current + degrees) % 4;
            }
        }

        public override double PartB()
        {
            var waypoint = (10, 1); // E/W , N/S
            var position = (0, 0);

            foreach (var i in _instructions)
            {
                switch (i.Item1)
                {
                    case 'L':
                        waypoint = Left(i.Item2, waypoint);
                        break;
                    case 'R':
                        waypoint = Right(i.Item2, waypoint);
                        break;
                    case 'N':
                        waypoint = (waypoint.Item1, waypoint.Item2 + i.Item2);
                        break;
                    case 'S':
                        waypoint = (waypoint.Item1, waypoint.Item2 - i.Item2);
                        break;
                    case 'W':
                        waypoint = (waypoint.Item1 - i.Item2, waypoint.Item2);
                        break;
                    case 'E':
                        waypoint = (waypoint.Item1 + i.Item2, waypoint.Item2);
                        break;
                    case 'F':
                        position = (position.Item1 + (i.Item2 * waypoint.Item1), position.Item2 + (i.Item2 * waypoint.Item2));
                        break;

                }
            }

            return Math.Abs(position.Item1) + Math.Abs(position.Item2);


            (int, int) Left(int degrees, (int, int) waypoint)
            {
                return degrees == 90 ? Right(270, waypoint) : degrees == 180 ? Right(180, waypoint) : Right(90, waypoint);

            }

            (int, int) Right(int degrees, (int, int) waypoint)
            {
                var times = degrees / 90;

                while (times-- > 0)
                    waypoint = (waypoint.Item2, waypoint.Item1 * -1);

                return waypoint;
            }
        }
    }
}
