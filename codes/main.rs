use std::time::{Duration, Instant};
use device_query::{DeviceQuery, DeviceState, Keycode};
use std::thread::sleep;

fn main() {
    let device_state = DeviceState::new();
    let mut esc_count = 0;
    let mut last_press_time = Instant::now();

    println!("Press ESC 8 times, then wait for 3 seconds.");

    loop {
        let keys: Vec<Keycode> = device_state.get_keys();
        
        if keys.contains(&Keycode::Escape) {
            let current_time = Instant::now();
            if current_time.duration_since(last_press_time) > Duration::from_millis(100) {
                esc_count += 1;
                println!("ESC pressed {} times", esc_count);
                last_press_time = current_time;

                if esc_count == 8 {
                    println!("Waiting for 3 seconds of inactivity...");
                    sleep(Duration::from_secs(3));
                    if device_state.get_keys().is_empty() {
                        println!("3 seconds passed without input. Stopping in 10 minutes.");
                        sleep(Duration::from_secs(600)); // 10 minutes
                        println!("Program stopped.");
                        break;
                    }
                }
            }
        }

        sleep(Duration::from_millis(10)); // Small delay to reduce CPU usage
    }
}