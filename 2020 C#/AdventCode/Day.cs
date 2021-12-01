using System;
using System.Diagnostics;
using System.IO;

namespace AdventCode
{
    public abstract class Day
    {
        public abstract int Number { get; }
        public string Input { get; }

        public string[] Lines { get; }

        protected Day()
        {
            Input = File.ReadAllText($@"days\day{Number}.txt");
            Lines = Input.GetLines();
        }


        public void Run()
        {
            var time = new Stopwatch();

            Console.WriteLine($"Day {Number}:");
            time.Start();
            var result = PartA();
            Console.WriteLine($"\tPartA: ({time.Elapsed})\t{result}");
            time.Restart();
            result = PartB();
            Console.WriteLine($"\tPartB: ({time.Elapsed})\t{result}");
        }

        public abstract double PartA();
        public abstract double PartB();
    }
}
