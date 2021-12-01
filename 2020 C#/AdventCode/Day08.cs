using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    public class Day08 : Day
    {
        public override int Number => 8;

        public Day08()
        {
            _commands = Lines.Select(x =>
            {
                var tmp = x.Split(" ");
                return new Command(tmp[0], int.Parse(tmp[1]));
            }).ToList();
        }


        public override double PartA()
        {
            return Accumulate(_commands).Item1;
        }

        public override double PartB()
        {
            foreach (var cmd in _commands)
            {
                var backup = cmd.Op;
                switch (cmd.Op)
                {
                    case "acc":
                        continue;
                    case "jmp":
                        cmd.Op = "nop";
                        break;
                    case "nop":
                        cmd.Op = "jmp";
                        break;
                }

                var (value, success) = Accumulate(_commands);
                if (success)
                    return value;

                cmd.Op = backup;
            }


            return -1;
        }


        private (int, bool) Accumulate(IEnumerable<Command> lines)
        {
            var linesClone = lines.Select(x => new Command(x.Op, x.Val)).ToList();

            var pos = 0;
            var result = 0;

            while (pos < linesClone.Count)
            {
                if (linesClone[pos].Executed)
                {
                    return (result, false);
                }
                linesClone[pos].Executed = true;

                switch (linesClone[pos].Op)
                {
                    case "acc":
                        result += linesClone[pos].Val;
                        pos++;
                        break;
                    case "jmp":
                        pos += linesClone[pos].Val;
                        break;
                    default:
                        pos++;
                        break;
                }
            }

            return (result, true);
        }


        private readonly List<Command> _commands;

        private class Command
        {
            public Command(string op, int val)
            {
                Op = op;
                Val = val;
                Executed = false;
            }

            public bool Executed { get; set; }
            public string Op { get; set; }
            public int Val { get; }
        }
    }
}