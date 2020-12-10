using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdventCode
{
    public class Day04 : Day
    {
        public override int Number => 4;

        private readonly string[] _fields = { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
        private readonly List<string> _passports;

        public Day04()
        {
            _passports = Input
                .Replace($"{Environment.NewLine}{Environment.NewLine}", "Ñ")
                .Replace(Environment.NewLine, " ")
                .Split("Ñ")
                .ToList();
        }

        public override double PartA()
        {
            return _passports.Count(pass => _fields.All(pass.Contains));
        }

        public override double PartB()
        {
            var result = _passports
                .Select(x => JsonConvert.DeserializeObject<Passport>($"{{\"{x.Replace(" ", "\",\"").Replace(":", "\":\"")}\"}}"))
                .Count(x => x.IsValid());

            return result;
        }


        public class Passport
        {
            public string byr { get; set; } //(Birth Year) - four digits; at least 1920 and at most 2002.
            public string iyr { get; set; } //(Issue Year) - four digits; at least 2010 and at most 2020.
            public string eyr { get; set; } //(Expiration Year) - four digits; at least 2020 and at most 2030.

            public string hgt { get; set; } //(Height) - a number followed by either cm or in:
            //If cm, the number must be at least 150 and at most 193.
            //If in, the number must be at least 59 and at most 76.
            public string hcl { get; set; } //(Hair Color) - a # followed by exactly six characters 0-9 or a-f.
            public string ecl { get; set; } //(Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
            public string pid { get; set; } //(Passport ID) - a nine-digit number, including leading zeroes.


            private readonly string[] validEyes = { "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };
            private readonly Regex validHair = new Regex("^#[0-9a-f]{6}$");
            private readonly Regex validPid = new Regex("^[0-9]{9}$");

            public bool IsValid()
            {

                if (string.IsNullOrEmpty(hgt) ||
                    string.IsNullOrEmpty(hcl) ||
                    string.IsNullOrEmpty(ecl) ||
                    string.IsNullOrEmpty(pid) ||
                    string.IsNullOrEmpty(byr) ||
                    string.IsNullOrEmpty(iyr) ||
                    string.IsNullOrEmpty(eyr))
                {
                    return false;
                }

                if (hgt.Contains("cm"))
                {
                    var height = int.Parse(hgt.Replace("cm", ""));
                    if (!Between(height, 150, 193))
                        return false;
                }
                else if (hgt.Contains("in"))
                {
                    var height = int.Parse(hgt.Replace("in", ""));
                    if (!Between(height, 59, 76))
                        return false;
                }
                else
                {
                    return false;
                }

                if (!validHair.IsMatch(hcl))
                    return false;

                if (!validEyes.Contains(ecl))
                    return false;

                if (!validPid.IsMatch(pid))
                    return false;

                return
                    Between(int.Parse(byr), 1920, 2002) &&
                    Between(int.Parse(iyr), 2010, 2020) &&
                    Between(int.Parse(eyr), 2020, 2030);
            }

            private bool Between(int field, int min, int max)
            {
                return min <= field && field <= max;
            }
        }
    }
}
