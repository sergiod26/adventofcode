using System;
using System.Collections.Generic;
using System.Linq;

namespace AdventCode
{
    class Day21 : Day
    {
        public override int Number => 21;

        private readonly Dictionary<string, int> _ingredients = new Dictionary<string, int>();
        private readonly Dictionary<string, List<string>> _allergens = new Dictionary<string, List<string>>();

        public Day21()
        {
            foreach (var line in Lines)
            {
                var splitLine = line.Split(" (contains ");
                var splitIngredients = splitLine[0].Split(" ").ToList();

                foreach (var ingredient in splitIngredients)
                {
                    if (_ingredients.ContainsKey(ingredient))
                    {
                        _ingredients[ingredient]++;
                    }
                    else
                    {
                        _ingredients[ingredient] = 1;
                    }
                }

                var splitAllergens = splitLine[1].Replace(")", string.Empty).Split(", ");

                foreach (var allergen in splitAllergens)
                {
                    if (_allergens.ContainsKey(allergen))
                    {
                        _allergens[allergen] = _allergens[allergen].Intersect(splitIngredients).ToList();
                    }
                    else
                    {
                        _allergens[allergen] = splitIngredients;
                    }
                }
            }
        }

        public override double PartA()
        {
            //return 0;
            List<string> allergenFoods = new List<string>();

            do
            {
                var tmp = _allergens.Where(x => x.Value.Count == 1).ToList();
                allergenFoods.AddRange(tmp.Select(x => x.Value.First()));

                foreach (var x in tmp)
                {
                    _allergens.Remove(x.Key);
                }

                var allergentKeys = _allergens.Keys.ToList();
                foreach (var allergen in allergentKeys)
                {
                    _allergens[allergen] = _allergens[allergen].Where(x => !allergenFoods.Contains(x)).ToList();
                }
            } while (_allergens.Any());

            var sum = _ingredients.Where(x => !allergenFoods.Contains(x.Key)).Sum(x => x.Value);
            
            return sum;
        }

        public override double PartB()
        {
            List<string> allergenFoods = new List<string>();

            do
            {
                var ready = _allergens.Where(x => x.Value.Count == 1).ToList();
                allergenFoods.AddRange(ready.Select(x => x.Value.First()));

                var pending = _allergens.Where(x => x.Value.Count > 1).ToList();

                var allergentKeys = pending.Select(x => x.Key).ToList();
                foreach (var allergen in allergentKeys)
                {
                    _allergens[allergen] = _allergens[allergen].Where(x => !allergenFoods.Contains(x)).ToList();
                }
            } while (_allergens.Any(x => x.Value.Count > 1));


            var result = string.Join(',', _allergens.OrderBy(x => x.Key).Select(x => x.Value.First()));
            Console.WriteLine(result);

            return 0;
        }
    }
}
