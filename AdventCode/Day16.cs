using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day16 : Day
    {
        private readonly List<Rule> _rules = new List<Rule>();


        private List<List<int>> _tickets;
        private List<long> _myTicket;

        public override int Number => 16;


        public Day16()
        {
            var i = 0;

            while (Lines[i] != "your ticket:")
            {
                var line = Lines[i++].Split(new[] { ": ", " or " }, StringSplitOptions.RemoveEmptyEntries);
                _rules.Add(new Rule
                {
                    Name = line[0],
                    Ranges = line.Skip(1).Select(r =>
                    {
                        var values = r.Split('-');
                        return (int.Parse(values[0]), int.Parse(values[1]));
                    }).ToList()
                });
            }

            _myTicket = Lines[++i].Split(',').Select(long.Parse).ToList();

            _tickets = Lines.Skip(i + 2).Select(x => x.Split(',').Select(int.Parse).ToList()).ToList();
        }

        public override double PartA()
        {
            var result = _tickets.SelectMany(ticket => ticket.Where(num => _rules.All(rule => rule.Ranges.All(range => !Between(num, range.Item1, range.Item2)))).ToList()).Sum();

            return result;//28884
        }

        public override double PartB()
        {
            var ticketValuesSize = _myTicket.Count;
            var ruleNames = _rules.Select(r => r.Name).ToList();


            var validTickets = _tickets.Where(ticket => ticket.All(num => _rules.Any(rule => rule.Ranges.Any(range => Between(num, range.Item1, range.Item2))))).ToList();

            var wrong = Enumerable.Range(0, ticketValuesSize).Select(i => new HashSet<string>()).ToArray();

            foreach (var ticket in validTickets)
            {
                for (var i = 0; i < ticket.Count; i++)
                {
                    var mismatch = _rules.Where(rule => !rule.Success(ticket[i])).Select(r => r.Name).ToList();
                    foreach (var m in mismatch)
                    {
                        wrong[i].Add(m);
                    }
                }
            }



            var options = wrong.Select((x, ix) => (ruleNames.Except(x).ToList(), ix)).OrderBy(x => x.Item1.Count).ToList();

            var finalPositions = new List<(string, int)> { (options.First().Item1.First(), 0) };

            for (var i = 1; i < ticketValuesSize; i++)
            {
                finalPositions.Add((options[i].Item1.Except(options[i - 1].Item1).Single(), options[i].ix));
            }

            var indexes = finalPositions.Where(x => x.Item1.Contains("departure")).Select(x => x.Item2).ToList();

            long result = 1;

            foreach (var ix in indexes)
            {
                result *= _myTicket[ix];
            }

            return result;
        }


        class Rule
        {
            public string Name { get; set; }
            public List<(int, int)> Ranges { get; set; }

            public bool Success(int number)
            {
                return Ranges.Any(r => Between(number, r.Item1, r.Item2));
            }

            private bool Between(int field, int min, int max)
            {
                return min <= field && field <= max;
            }
        }

        private bool Between(int field, int min, int max)
        {
            return min <= field && field <= max;
        }
    }
}
