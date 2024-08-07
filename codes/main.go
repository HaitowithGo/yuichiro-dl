package main

import (
	"fmt"
	"os"
	"time"

	"github.com/eiannone/keyboard"
)

func main() {
	if err := keyboard.Open(); err != nil {
		panic(err)
	}
	defer keyboard.Close()

	escCount := 0
	lastPressTime := time.Now()

	fmt.Println("Press ESC 8 times, then wait for 3 seconds.")

	for {
		char, key, err := keyboard.GetKey()
		if err != nil {
			panic(err)
		}

		if key == keyboard.KeyEsc {
			currentTime := time.Now()
			if currentTime.Sub(lastPressTime) > 100*time.Millisecond { // Debounce
				escCount++
				fmt.Printf("ESC pressed %d times\n", escCount)
				lastPressTime = currentTime

				if escCount == 8 {
					fmt.Println("Waiting for 3 seconds of inactivity...")
					time.Sleep(3 * time.Second)
					if !isKeyPressed() {
						fmt.Println("3 seconds passed without input. Stopping in 10 minutes.")
						time.Sleep(10 * time.Minute)
						fmt.Println("Program stopped.")
						os.Exit(0)
					}
				}
			}
		}

		if char == 'q' {
			break
		}
	}
}

func isKeyPressed() bool {
	_, _, err := keyboard.GetKey()
	return err == nil
}