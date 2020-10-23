using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace csharp.Solutions
{
    public class Day01
    {
        static string InputFilename = "./Inputs/Day01.txt";

        public static int FuelForModule(int mass) =>
            mass / 3 - 2;


        public static IEnumerable<int> ReadFile(string filename)
            => File.ReadLines(filename).Select(line => int.Parse(line));

        public static bool Test(int input, int expected)
        {
            if (FuelForModule(input) is var val && val == expected)
            {
                Console.WriteLine($"Passed: {input} {val}");
                return true;
            }
            else
            {
                Console.WriteLine($"Failed: {input} {val} !== {expected}");
                return false;
            }
        }

        public record Case(int input, int expected);
        public static List<Case> Cases = new()
        {
            new(12, 2),
            new(14, 2),
            new(1969, 654),
            new(100756, 33583)
        };

        public static bool RunCases() =>
            Cases.Any(c => Test(c.input, c.expected));

        public static int RunA(string filename) =>
            ReadFile(filename)
                .Select(input => FuelForModule(input))
                .Sum();

        public static int RunA() => RunA(InputFilename);

        public static int FuelForModuleB(int input) =>
            FuelForModule(input) switch
            {
                var val when val > 0 => val + FuelForModuleB(val),
                _ => 0
            };

        public static int RunB(string filename) =>
            ReadFile(filename)
                .Select(input => FuelForModuleB(input))
                .Sum();

        public static int RunB() => RunB(InputFilename);
    }
}