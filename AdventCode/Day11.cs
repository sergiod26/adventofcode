using System.Linq;
using Math = System.Math;

namespace AdventCode
{
    class Day11 : Day
    {
        private char[][] _seats;
        private readonly int _cols;
        private readonly int _rows;
        public override int Number => 11;

        public Day11()
        {
            _seats = Lines.Select(x => x.Select(y => y).ToArray()).ToArray();
            _cols = _seats[0].Length;
            _rows = _seats.Length;
        }

        public override double PartA()
        {
            while (Round(4)) { }
            var result = _seats.SelectMany(x => x).Count(x => x == '#');
            return result;
        }

        public override double PartB()
        {
            _seats = Lines.Select(x => x.Select(y => y).ToArray()).ToArray();

            var sight = Math.Max(_rows, _cols);
            while (Round(5, sight)) { }
            var result = _seats.SelectMany(x => x).Count(x => x == '#');
            return result;
        }

        private bool Round(int tolerance, int sight = 1)
        {
            var seatsTmp = _seats.Select(x => x.Select(y => y).ToArray()).ToArray();
            var changed = false;

            for (var i = 0; i < _rows; i++)
            {
                for (var j = 0; j < _cols; j++)
                {
                    switch (_seats[i][j])
                    {
                        case '.':
                            continue;
                        case 'L' when CountOccupied(i, j, sight) == 0:
                            seatsTmp[i][j] = '#';
                            changed = true;
                            break;
                        case '#' when CountOccupied(i, j, sight) >= tolerance:
                            seatsTmp[i][j] = 'L';
                            changed = true;
                            break;
                    }
                }
            }

            _seats = seatsTmp;

            return changed;
        }



        private int CountOccupied(int i, int j, int sight)
        {
            var occupied =
                IsOccupied(i, j, -1, -1, sight)
                + IsOccupied(i, j, -1, 0, sight)
                + IsOccupied(i, j, -1, 1, sight)
                + IsOccupied(i, j, 0, -1, sight)
                + IsOccupied(i, j, 0, 1, sight)
                + IsOccupied(i, j, 1, -1, sight)
                + IsOccupied(i, j, 1, 0, sight)
                + IsOccupied(i, j, 1, 1, sight);

            return occupied;
        }

        private int IsOccupied(int i, int j, int vertical, int horizontal, int sight)
        {
            for (var k = 1; k <= sight; k++)
            {
                if (i + k * vertical < 0 || j + k * horizontal < 0 ||
                    i + k * vertical >= _rows || j + k * horizontal >= _cols ||
                    _seats[i + k * vertical][j + k * horizontal] == 'L')
                {
                    return 0;
                }


                if (_seats[i + k * vertical][j + k * horizontal] == '#')
                {
                    return 1;
                }
            }

            return 0;
        }
    }
}
