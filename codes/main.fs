open System
open System.Threading

let mutable escCount = 0
let mutable lastPressTime = DateTime.Now

printfn "Press ESC 8 times, then wait for 3 seconds."

let rec loop() =
    if Console.KeyAvailable then
        let key = Console.ReadKey(true)
        if key.Key = ConsoleKey.Escape then
            let currentTime = DateTime.Now
            if (currentTime - lastPressTime).TotalMilliseconds > 100.0 then  // Debounce
                escCount <- escCount + 1
                printfn "ESC pressed %d times" escCount
                lastPressTime <- currentTime

                if escCount = 8 then
                    printfn "Waiting for 3 seconds of inactivity..."
                    Thread.Sleep(3000)
                    if not Console.KeyAvailable then
                        printfn "3 seconds passed without input. Stopping in 10 minutes."
                        Thread.Sleep(600000)  // 10 minutes
                        printfn "Program stopped."
                        exit 0

    Thread.Sleep(10)  // Small delay to reduce CPU usage
    loop()

loop()