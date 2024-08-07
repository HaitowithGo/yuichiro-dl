require 'io/console'

esc_count = 0
last_press_time = Time.now

puts "Press ESC 8 times, then wait for 3 seconds."

loop do
  if IO.console.getch == "\e"
    current_time = Time.now
    if current_time - last_press_time > 0.1 # Debounce
      esc_count += 1
      puts "ESC pressed #{esc_count} times"
      last_press_time = current_time

      if esc_count == 8
        puts "Waiting for 3 seconds of inactivity..."
        sleep 3
        if IO.console.wait_readable(0.1).nil?
          puts "3 seconds passed without input. Stopping in 10 minutes."
          sleep 600 # 10 minutes
          puts "Program stopped."
          break
        end
      end
    end
  end

  sleep 0.01 # Small delay to reduce CPU usage
end