using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day24 : Day
    {
        public override int Number => 24;

        public override double PartA()
        {
            _blacks = new Dictionary<(int, int), bool>();

            foreach (var line in Lines)
            {
                var current = (0, 0);

                for (int i = 0; i < line.Length; i++)
                {
                    if (line[i] == 'e')
                    {
                        current = (current.Item1, current.Item2 + 2);
                    }
                    else if (line[i] == 'w')
                    {
                        current = (current.Item1, current.Item2 - 2);
                    }
                    else if (line[i] == 'n')
                    {
                        if (line[++i] == 'e')
                        {
                            current = (current.Item1 - 1, current.Item2 + 1);
                        }
                        else if (line[i] == 'w')
                        {
                            current = (current.Item1 - 1, current.Item2 - 1);
                        }
                    }
                    else if (line[i] == 's')
                    {
                        if (line[++i] == 'e')
                        {
                            current = (current.Item1 + 1, current.Item2 + 1);
                        }
                        else if (line[i] == 'w')
                        {
                            current = (current.Item1 + 1, current.Item2 - 1);
                        }
                    }
                }

                if (_blacks.ContainsKey(current))
                {
                    _blacks.Remove(current);
                }
                else
                {
                    _blacks[current] = true;
                }

            }

            return _blacks.Count;
        }


        readonly Dictionary<(int, int), int> _neighborsTracker = new Dictionary<(int, int), int>();
        private Dictionary<(int, int), bool> _blacks;

        public override double PartB()
        {
            for (var counter = 0; counter < 100; counter++)
            {
                foreach (var (x, y) in _blacks.Keys)
                {
                    FlagWhiteNeighbors(x, y);
                }

                var toBlack = _neighborsTracker.Where(x => x.Value == 2).Select(x => x.Key).ToList();
                var toWhite = _blacks.Keys.Where(key =>
                {
                    var (x, y) = key;

                    int blackNeighbors = 0;

                    if (_blacks.ContainsKey((x, y + 2)))
                    {
                        blackNeighbors++;
                    }
                    if (_blacks.ContainsKey((x, y - 2)))
                    {
                        blackNeighbors++;
                    }
                    if (_blacks.ContainsKey((x + 1, y + 1)))
                    {
                        blackNeighbors++;
                    }
                    if (_blacks.ContainsKey((x + 1, y - 1)))
                    {
                        blackNeighbors++;
                    }
                    if (_blacks.ContainsKey((x - 1, y + 1)))
                    {
                        blackNeighbors++;
                    }
                    if (_blacks.ContainsKey((x - 1, y - 1)))
                    {
                        blackNeighbors++;
                    }

                    return blackNeighbors == 0 || blackNeighbors > 2;
                }).ToList();

                foreach (var tile in toBlack)
                {
                    _blacks[tile] = true;
                }


                foreach (var tile in toWhite)
                {
                    _blacks.Remove(tile);
                }

                _neighborsTracker.Clear();

            }
            return _blacks.Count;
        }

        void FlagWhiteNeighbors(int x, int y)
        {
            AddOrCount(x, y + 2);
            AddOrCount(x, y - 2);
            AddOrCount(x + 1, y + 1);
            AddOrCount(x + 1, y - 1);
            AddOrCount(x - 1, y + 1);
            AddOrCount(x - 1, y - 1);

            void AddOrCount(int x1, int y1)
            {
                if (_blacks.ContainsKey((x1, y1)))
                {
                    return;
                }

                if (_neighborsTracker.ContainsKey((x1, y1)))
                {
                    _neighborsTracker[(x1, y1)]++;
                }
                else
                {
                    _neighborsTracker[(x1, y1)] = 1;
                }
            }

        }
    }
}
