using System;

using csharp.Solutions;

namespace csharp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World!");
            var result = Day01.RunA();
            Console.WriteLine($"Result: {result}");
            result = Day01.RunB();
            Console.WriteLine($"Result: {result}");
        }
    }
}
