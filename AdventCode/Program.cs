using System;
using System.Linq;
using System.Text.RegularExpressions;

namespace AdventCode
{
    class Program
    {
        static void Main()
        {
            var regex = new Regex("Day(\\d+)");

            var classes = AppDomain.CurrentDomain.GetAssemblies()
                .SelectMany(x => x.GetTypes())
                .Where(x => typeof(Day).IsAssignableFrom(x) && !x.IsInterface && !x.IsAbstract)
                .OrderBy(x => int.Parse(regex.Match(x.Name).Groups[1].Value));

            bool all = false;
            if (all)
            {
                foreach (var c in classes)
                {
                    ((Day)Activator.CreateInstance(c))?.Run();
                }
            }
            else
            {
                ((Day)Activator.CreateInstance(classes.Last()))?.Run();
            }
        }
    }
}
