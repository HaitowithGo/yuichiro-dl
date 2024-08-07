using System;
using System.Threading;

class Program
{
    static void Main()
    {
        int escCount = 0;
        DateTime lastPressTime = DateTime.Now;

        Console.WriteLine("Press ESC 8 times, then wait for 3 seconds.");

        while (true)
        {
            if (Console.KeyAvailable)
            {
                var key = Console.ReadKey(true);
                if (key.Key == ConsoleKey.Escape)
                {
                    var currentTime = DateTime.Now;
                    if ((currentTime - lastPressTime).TotalMilliseconds > 100)  // Debounce
                    {
                        escCount++;
                        Console.WriteLine($"ESC pressed {escCount} times");
                        lastPressTime = currentTime;

                        if (escCount == 8)
                        {
                            Console.WriteLine("Waiting for 3 seconds of inactivity...");
                            Thread.Sleep(3000);
                            if (!Console.KeyAvailable)
                            {
                                Console.WriteLine("3 seconds passed without input. Stopping in 10 minutes.");
                                Thread.Sleep(600000);  // 10 minutes
                                Console.WriteLine("Program stopped.");
                                break;
                            }
                        }
                    }
                }
            }
            Thread.Sleep(10);  // Small delay to reduce CPU usage
        }
    }
}