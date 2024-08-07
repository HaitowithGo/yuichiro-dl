import keyboard
import time

def main():
    esc_count = 0
    last_press_time = time.time()

    print("Press ESC 8 times, then wait for 3 seconds.")

    while True:
        if keyboard.is_pressed('esc'):
            current_time = time.time()
            if current_time - last_press_time > 0.1:  # Debounce
                esc_count += 1
                print(f"ESC pressed {esc_count} times")
                last_press_time = current_time

                if esc_count == 8:
                    print("Waiting for 3 seconds of inactivity...")
                    time.sleep(3)
                    if not keyboard.is_pressed('esc'):
                        print("3 seconds passed without input. Stopping in 10 minutes.")
                        time.sleep(600)  # 10 minutes
                        print("Program stopped.")
                        break

        time.sleep(0.01)  # Small delay to reduce CPU usage

if __name__ == "__main__":
    main()