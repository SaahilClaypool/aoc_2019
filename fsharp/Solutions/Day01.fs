namespace AOC.Solutions
open System.IO
module Day01 =
    let fuelForModule mass =
        (mass / 3) - 2

    let test (input, expected) =
        let calculated = fuelForModule(input)
        if calculated = expected then
            printf "passed: %d %d %d\n" input calculated expected
            true
        else
            printf "failed: %d %d %d\n" input calculated expected
            false


    let runCases =
        let cases = 
            [
                (12, 2);
                (14, 2);
                (1969, 654);
                (100756, 33583)
            ]
        cases
            |> Seq.map(
                fun testcase -> 
                    let (input, expected) = testcase
                    test(input, expected)
            )
    let readLines (filePath:string) = seq {
        use sr = new StreamReader (filePath)
        while not sr.EndOfStream do
            yield sr.ReadLine ()
    }
    let runA filename =
        (readLines(filename)) |>
            Seq.sumBy (int >> fuelForModule) 

    let rec fuelForModuleB mass =
        let m = fuelForModule mass
        if m >= 0 then
            m + fuelForModuleB(m)
        else
            0

    let runB filename =
        (readLines(filename)) |>
            Seq.sumBy (int >> fuelForModuleB) 

        
        