using System;

namespace AdventCode
{
    public static class Extensions
    {
        public static string[] GetLines(this string input) =>
             input.Split(new[] { "\n", "\r\n" }, StringSplitOptions.RemoveEmptyEntries);

    }
}
