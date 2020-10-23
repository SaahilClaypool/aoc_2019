namespace AOC.Solutions

open System

module DayTwo =
    let inputToInts (inputString: string) = 
        inputString.Split(",")
            |> Seq.map(fun el -> int(el))
    let day2Main = printf "day 2\n"
