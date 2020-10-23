namespace AOC

open System
open System.Collections.Generic
open AOC.Solutions

module Main =

    // Define a function to construct a message to print
    let from whom = sprintf "from %s" whom

    let rec fibo value =
        if value < 2 then 1 else fibo (value - 1) + fibo (value - 2)

    let fastFibo value =
        let cache = new List<int>()
        cache.Add(1)
        cache.Add(1)
        for index in seq { 2 .. value } do
            printf "index is %d\n" index
            cache.Add(cache.Item(index - 1) + cache.Item(index - 2))
        cache.Item(value)

    [<EntryPoint>]
    let main argv =
        for res in Day01.runCases do
            0
        let res = Day01.runA "./Inputs/Day01.txt"
        printf "Result for day 1 A = %d\n" res
        let res = Day01.runB "./Inputs/Day01.txt"
        printf "Result for day 1 B = %d\n" res
        0 // return an integer exit code
