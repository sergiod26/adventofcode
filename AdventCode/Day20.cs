using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdventCode
{
    class Day20 : Day
    {
        public override int Number => 20;

        private readonly List<Tile> _tiles;

        public Day20()
        {
            var regex = new Regex("\\d+");
            _tiles = new List<Tile>();

            for (var i = 0; i < Lines.Length; i++)
            {
                var id = long.Parse(regex.Match(Lines[i++]).Value);

                var j = 0;
                for (; j + i < Lines.Length && !regex.IsMatch(Lines[j + i]); j++) ;

                var data = Lines.Skip(i).Take(j).Select(s => s.Select(c => c).ToArray()).ToArray();
                _tiles.Add(new Tile(id, data));


                i += (j - 1);
            }

            foreach (var tile in _tiles)
            {
                var allSides = _tiles.Except(new List<Tile> { tile }).SelectMany(x => x.Borders).ToList();
                foreach (var border in tile.Borders)
                {
                    tile.BordersReps.Add(allSides.Count(x => Equivalent(border, x)));
                }
            }
        }

        public override double PartA()
        {
            var result = _tiles.Where(x => x.IsCorner()).Aggregate<Tile, long>(1, (current, tile) => current * tile.Id);
            return result;
        }

        public override double PartB()
        {
            var next = _tiles.First(x => x.IsCorner());
            _tiles.Remove(next);


            while (next.BordersReps[0] != 0 || next.BordersReps[3] != 0)
            {
                next = RotateTile(next);
            }

            var singleImageMatrix = new List<List<Tile>>();

            while (_tiles.Any())
            {
                var row = GetImageRow(next);
                singleImageMatrix.Add(row);

                if (!_tiles.Any())
                {
                    break;
                }

                var bottom = row.First().Borders[(int)Side.Bottom];
                next = _tiles.Single(tile => tile.Borders.Any(b => Equivalent(b, bottom)));
                _tiles.Remove(next);
                next = MatchTile(next, Side.Top, bottom);
            }


            var actualImage = new List<string>();
            foreach (var matrixTiles in singleImageMatrix.Select(row => row.Select(t => t.GetImageNoBorders()).ToList()))
            {
                for (var i = 0; i < matrixTiles.First().Count; i++)
                {
                    actualImage.Add(string.Join("", matrixTiles.Select(x => x[i])));
                }
            }

            var ret = CheckWithRotation(actualImage);

            if (ret < 0)
            {
                ret = CheckWithRotation(Flip(actualImage.Select(x => x.Select(y => y).ToArray()).ToArray()).Select(x => string.Join("", x)).ToList());
            }

            return ret;
        }

        private int CheckWithRotation(List<string> image)
        {
            var imageCopy = image.Select(x => new string(x)).ToList();


            for (var i = 0; i < 4; i++)
            {
                var result = CheckMonster(imageCopy);

                if (result > 0)
                    return result;

                imageCopy = RotateCounter(imageCopy.Select(x => x.Select(y => y).ToArray()).ToArray()).Select(x => string.Join("", x)).ToList();
            }

            return -1;
        }

        private int CheckMonster(List<string> lines)
        {
            var counter = 0;

            var monsterSize = 20;
            var monster0 = new Regex("..................#.");
            var monster1 = new Regex("#....##....##....###");
            var monster2 = new Regex(".#..#..#..#..#..#...");

            for (var i = 0; i < lines.Count; i++)
            {
                if (!monster1.IsMatch(lines[i]))
                    continue;

                var matches = monster1.Matches(lines[i]);

                foreach (Match m in matches)
                {
                    var indexOf = lines[i].IndexOf(m.Value, StringComparison.Ordinal);

                    if (monster0.IsMatch(lines[i - 1].Substring(indexOf, monsterSize)) && monster2.IsMatch(lines[i + 1].Substring(indexOf, monsterSize)))
                    {
                        counter++;
                    }
                }
            }

            if (counter <= 0)
            {
                return -1;
            }

            var sharps = lines.SelectMany(x => x).Count(x => x == '#');
            var result = sharps - (counter * 15);   //Potential issue: overlapping monsters

            return result;

        }

        private List<Tile> GetImageRow(Tile next)
        {
            var row = new List<Tile> { next };

            while (next.BordersReps[(int)Side.Right] != 0)
            {
                next = _tiles.Single(tile => tile.Borders.Any(b => Equivalent(row.Last().Borders[(int)Side.Right], b)));
                _tiles.Remove(next);
                next = MatchTile(next, Side.Left, row.Last().Borders[(int)Side.Right]);
                row.Add(next);
            }

            return row;
        }

        private Tile MatchTile(Tile tile, Side side, string val)
        {
            var sideInt = (int)side;

            for (var i = 0; i < 8; i++)
            {
                if (tile.Borders[sideInt] == val)
                {
                    return tile;
                }

                tile = RotateTile(tile);
                if (i == 3)
                {
                    tile = FlipTile(tile);
                }
            }

            throw new Exception("Not Found");
        }

        private Tile FlipTile(Tile tile)
        {
            var newTile = new Tile(tile.Id, Flip(tile.Data))
            {
                BordersReps = new List<int>
                {
                    tile.BordersReps[2],
                    tile.BordersReps[1],
                    tile.BordersReps[0],
                    tile.BordersReps[3]

                }
            };

            return newTile;
        }

        private Tile RotateTile(Tile tile)
        {
            var newTile = new Tile(tile.Id, RotateCounter(tile.Data))
            {
                BordersReps = new List<int>
                {
                    tile.BordersReps[1],
                    tile.BordersReps[2],
                    tile.BordersReps[3],
                    tile.BordersReps[0]
                }
            };

            return newTile;
        }


        bool Equivalent(string str1, string str2)
        {
            return str1.Equals(str2) || string.Join("", str1.Reverse()).Equals(str2);
        }



        char[][] RotateCounter(char[][] oldMatrix)
        {
            var dimensionX = oldMatrix.Length;
            var dimensionY = oldMatrix[0].Length;
            var newMatrix = new char[dimensionX][];
            for (var i = 0; i < newMatrix.Length; i++)
            {
                newMatrix[i] = new char[dimensionY];
            }
            var newRow = 0;

            for (var oldColumn = dimensionX - 1; oldColumn >= 0; oldColumn--)
            {
                for (var oldRow = 0; oldRow < dimensionY; oldRow++)
                {
                    newMatrix[newRow][oldRow] = oldMatrix[oldRow][oldColumn];
                }
                newRow++;
            }
            return newMatrix;
        }



        char[][] Flip(char[][] mat)
        {
            return mat.Reverse().ToArray();
        }


        enum Side
        {
            Top,
            Right,
            Bottom,
            Left
        }

        class Tile
        {
            public long Id { get; }
            public char[][] Data { get; }


            public string[] Borders { get; } = new string[4];
            public List<int> BordersReps { get; set; } = new List<int>();

            public Tile(long id, char[][] data)
            {
                Id = id;
                Data = data;

                Borders[(int)Side.Top] = string.Join("", Data.First());
                Borders[(int)Side.Right] = string.Join("", Data.Select(x => x.Last()).ToArray());
                Borders[(int)Side.Bottom] = string.Join("", Data.Last().ToArray());
                Borders[(int)Side.Left] = string.Join("", Data.Select(x => x.First()).ToArray());
            }

            public bool IsCorner()
            {
                return BordersReps.Count(x => x == 0) == 2;
            }


            public List<string> GetImageNoBorders()
            {
                var size = Data.Length;
                return Data.Skip(1).Take(size - 2).Select(r => string.Join("", r.Skip(1).Take(size - 2))).ToList();
            }
        }
    }
}
