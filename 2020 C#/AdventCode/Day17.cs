using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day17 : Day
    {
        readonly Dictionary<(int, int, int), bool> _pocket;
        readonly Dictionary<(int, int, int), int> _neighborsTracker = new Dictionary<(int, int, int), int>();

        readonly Dictionary<(int, int, int, int), bool> _pocket4d;
        Dictionary<(int, int, int, int), int> _neighborsTracker4d = new Dictionary<(int, int, int, int), int>();

        public Day17()
        {
            _pocket = Lines.SelectMany((x, xIx) => x.Select((y, yIx) => (y, yIx)).Where(y => y.y == '#').Select(z => (xIx, z.yIx, 0))).ToDictionary(x => x, x => true);
            _pocket4d = Lines.SelectMany((x, xIx) => x.Select((y, yIx) => (y, yIx)).Where(y => y.y == '#').Select(z => (xIx, z.yIx, 0, 0))).ToDictionary(x => x, x => true);
        }

        public override int Number => 17;
        public override double PartA()
        {
            for (var counter = 0; counter < 6; counter++)
            {
                foreach (var (x, y, z) in _pocket.Keys)
                {
                    FlagNeighbors(x, y, z);
                }


                var toActive = _neighborsTracker.Where(x => x.Value == 3).Select(x => x.Key).ToList();
                var toInactive = _pocket.Keys.Where(key =>
                {
                    var (x, y, z) = key;
                    var active = ActiveNeighbors(x, y, z);
                    return active != 2 && active != 3;
                }).ToList();

                foreach (var cube in toActive)
                {
                    _pocket[cube] = true;
                }


                foreach (var cube in toInactive)
                {
                    _pocket.Remove(cube);
                }

                _neighborsTracker.Clear();
            }
            return _pocket.Count;
        }

        public override double PartB()
        {
            for (var counter = 0; counter < 6; counter++)
            {
                foreach (var (x, y, z, w) in _pocket4d.Keys)
                {
                    FlagNeighbors4d(x, y, z, w);
                }


                var toActive = _neighborsTracker4d.Where(x => x.Value == 3).Select(x => x.Key).ToList();
                var toInactive = _pocket4d.Keys.Where(key =>
                {
                    var (x, y, z, w) = key;
                    var active = ActiveNeighbors4d(x, y, z, w);
                    return active != 2 && active != 3;
                }).ToList();

                foreach (var cube in toActive)
                {
                    _pocket4d[cube] = true;
                }


                foreach (var cube in toInactive)
                {
                    _pocket4d.Remove(cube);
                }

                _neighborsTracker4d.Clear();
            }
            return _pocket4d.Count;
        }


        int ActiveNeighbors4d(int x, int y, int z, int w)
        {
            var active = 0;
            for (var i = -1; i < 2; i++)
            {
                for (var j = -1; j < 2; j++)
                {
                    for (var k = -1; k < 2; k++)
                    {
                        for (var l = -1; l < 2; l++)
                        {
                            if (i == 0 && j == 0 && k == 0 && l == 0)
                            {
                                continue;
                            }

                            if (_pocket4d.ContainsKey((x + i, y + j, z + k, w + l)))
                            {
                                active++;
                            }
                        }
                    }
                }
            }

            return active;
        }


        void FlagNeighbors4d(int x, int y, int z, int w)
        {
            for (var i = -1; i < 2; i++)
            {
                for (var j = -1; j < 2; j++)
                {
                    for (var k = -1; k < 2; k++)
                    {
                        for (var l = -1; l < 2; l++)
                        {
                            if (i == 0 && j == 0 && k == 0 && l == 0)
                            {
                                continue;
                            }


                            if (_neighborsTracker4d.ContainsKey((x + i, y + j, z + k, w + l)))
                            {
                                _neighborsTracker4d[(x + i, y + j, z + k, w + l)]++;
                            }
                            else
                            {
                                _neighborsTracker4d[(x + i, y + j, z + k, w + l)] = 1;
                            }
                        }
                    }
                }
            }
        }

        int ActiveNeighbors(int x, int y, int z)
        {
            var active = 0;
            for (var i = -1; i < 2; i++)
            {
                for (var j = -1; j < 2; j++)
                {
                    for (var k = -1; k < 2; k++)
                    {
                        if (i == 0 && j == 0 && k == 0)
                        {
                            continue;
                        }



                        if (_pocket.ContainsKey((x + i, y + j, z + k)))
                        {
                            active++;
                        }
                    }
                }
            }

            return active;
        }


        void FlagNeighbors(int x, int y, int z)
        {
            for (var i = -1; i < 2; i++)
            {
                for (var j = -1; j < 2; j++)
                {
                    for (var k = -1; k < 2; k++)
                    {
                        if (i == 0 && j == 0 && k == 0)
                        {
                            continue;
                        }


                        if (_neighborsTracker.ContainsKey((x + i, y + j, z + k)))
                        {
                            _neighborsTracker[(x + i, y + j, z + k)]++;
                        }
                        else
                        {
                            _neighborsTracker[(x + i, y + j, z + k)] = 1;
                        }
                    }
                }
            }
        }
    }
}
