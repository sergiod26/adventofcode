using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day18 : Day
    {
        public override int Number => 18;

        private readonly List<string> _operations;
        readonly Dictionary<char, int> _precedences = new Dictionary<char, int> { { '+', 0 }, { '*', 0 } };

        public Day18()
        {
            _operations = Lines.Select(x => x.Replace(" ", "")).ToList();
        }

        public override double PartA()
        {
            var ret = _operations.Sum(o => Calculate(Tokenize(o)));
            return ret;
        }

        public override double PartB()
        {
            _precedences['*'] = 1;
            var ret = _operations.Sum(o => Calculate(Tokenize(o)));
            return ret;
        }

        private long Calculate(List<Token> tokens)
        {
            for (var currentPrecedence = 0; tokens.Count != 1; currentPrecedence++)
            {
                for (var i = 0; i < tokens.Count - 2;)
                {
                    if (tokens[i + 1].Precedence == currentPrecedence)
                    {
                        var a = tokens[i].Parentheses.Any() ? Calculate(tokens[i].Parentheses) : tokens[i].Value;
                        var b = tokens[i + 2].Parentheses.Any() ? Calculate(tokens[i + 2].Parentheses) : tokens[i + 2].Value;
                        var op = tokens[i + 1].Op;

                        tokens.RemoveRange(i, 3);
                        tokens.Insert(i, new Token { Value = op(a, b) });
                    }
                    else
                    {
                        i += 2;
                    }
                }
            }

            return tokens.Single().Value;
        }

        private List<Token> Tokenize(string operation)
        {
            var tokens = new List<Token>();

            for (var ix = 0; ix < operation.Length; ix++)
            {
                var c = operation[ix];

                switch (c)
                {
                    case '+':
                        tokens.Add(new Token { Op = (a, b) => a + b, Precedence = _precedences[c] });
                        break;
                    case '*':
                        tokens.Add(new Token { Op = (a, b) => a * b, Precedence = _precedences[c] });
                        break;
                    case '(':
                        var parCount = 1;
                        var internalIx = ix + 1;

                        for (; ; internalIx++)
                        {
                            if (operation[internalIx] == '(')
                            {
                                parCount++;
                            }
                            if (operation[internalIx] == ')')
                            {
                                parCount--;
                                if (parCount == 0)
                                {
                                    break;
                                }
                            }
                        }

                        tokens.Add(new Token { Parentheses = Tokenize(operation.Substring(ix + 1, internalIx - ix - 1)) });
                        ix = internalIx;
                        break;

                    default:
                        var val = c.ToString();

                        while (ix + 1 < operation.Length && operation[ix + 1] >= '0' && operation[ix + 1] <= '9')
                        {
                            val += operation[ix++];
                        }
                        tokens.Add(new Token { Value = long.Parse(val) });
                        break;
                }
            }

            return tokens;
        }


        class Token
        {
            public long Value { get; set; }
            public Func<long, long, long> Op { get; set; }

            public List<Token> Parentheses = new List<Token>();
            public int Precedence { get; set; }
        }
    }
}
