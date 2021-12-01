using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day22 : Day
    {
        public override int Number => 22;

        private readonly Queue<long> _deck1;
        private readonly Queue<long> _deck2;

        public Day22()
        {
            var decks = new[] { new Queue<long>(), new Queue<long>() };
            var playerNum = 0;
            foreach (var line in Lines.Skip(1))
            {
                if (line == "Player 2:")
                {
                    playerNum++;
                    continue;
                }
                decks[playerNum].Enqueue(long.Parse(line));
            }

            _deck1 = new Queue<long>(decks[0]);
            _deck2 = new Queue<long>(decks[1]);
        }

        public override double PartA()
        {
            var (score1, score2) = PlayGame(new Queue<long>(_deck1), new Queue<long>(_deck2));
            return Math.Max(score1, score2);
        }

        public override double PartB()
        {
            var (score1, score2) = PlayGame(new Queue<long>(_deck1), new Queue<long>(_deck2), true);
            return Math.Max(score1, score2);
        }

        (long, long) PlayGame(Queue<long> deck1, Queue<long> deck2, bool recursiveVersion = false)
        {
            var usedDecks1 = new List<string>();
            var usedDecks2 = new List<string>();

            while (deck1.Any() && deck2.Any())
            {
                var hand1 = string.Join("-", deck1);
                var hand2 = string.Join("-", deck2);

                if (usedDecks1.Contains(hand1) || usedDecks2.Contains(hand2))
                {
                    return (1, 0);
                }
                usedDecks1.Add(hand1);
                usedDecks2.Add(hand2);

                var card1 = deck1.Dequeue();
                var card2 = deck2.Dequeue();

                var points1 = card1;
                var points2 = card2;

                if (recursiveVersion && deck1.Count >= card1 && deck2.Count >= card2)
                {
                    (points1, points2) = PlayGame(new Queue<long>(deck1.Take((int)card1)), new Queue<long>(deck2.Take((int)card2)));
                }

                if (points1 > points2)
                {
                    deck1.Enqueue(card1);
                    deck1.Enqueue(card2);
                }
                else
                {
                    deck2.Enqueue(card2);
                    deck2.Enqueue(card1);
                }
            }

            var cardsCount = deck1.Count + deck2.Count;
            return (deck1.Select((t, i) => t * (cardsCount - i)).Sum(), deck2.Select((t, i) => t * (cardsCount - i)).Sum());
        }
    }
}
