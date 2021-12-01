using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdventCode
{
    class Day19 : Day
    {
        private readonly Dictionary<string, string> _rules;
        private readonly List<string> _messages;


        public Day19()
        {
            var lines = Input.Split(new[] { "\n", "\r\n" }, StringSplitOptions.None).ToList();
            var separator = lines.IndexOf(string.Empty);

            _rules = lines.Take(separator).Select(x =>
            {
                var split = x.Replace("\"", "").Split(": ");
                return (split[0], split[1]);
            }).ToDictionary(x => x.Item1, x => x.Item2);

            _messages = lines.Skip(separator + 1).ToList();
        }

        public override int Number => 19;
        public override double PartA()
        {
            return Solve();
        }


        public override double PartB()
        {
            _rules["8"] = "(42+)";
            _rules["11"] = "((?'Open'42)+(?'Close-Open'31)+)(?(Open)(?!))";

            return Solve();
        }


        double Solve()
        {
            var numRegex = new Regex("\\d");
            var ruleStr = _rules["0"];

            while (numRegex.IsMatch(ruleStr))
            {
                ruleStr = Regex.Replace(ruleStr, "\\d+", m => $"({_rules[m.Value]})", RegexOptions.None);
            }

            var ruleRegex = new Regex($"^{ruleStr.Replace(" ", "")}$");
            var result = _messages.Count(m => ruleRegex.IsMatch(m));

            return result;
        }
    }
}
