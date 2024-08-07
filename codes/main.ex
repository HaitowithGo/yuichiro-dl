defmodule EscDetection do
  def start do
    IO.puts "Press ESC 8 times, then wait for 3 seconds."
    loop(0, :os.system_time(:milli_seconds))
  end

  defp loop(8, last_press_time) do
    IO.puts "Waiting for 3 seconds of inactivity..."
    :timer.sleep(3000)
    if :os.system_time(:milli_seconds) - last_press_time >= 3000 do
      IO.puts "3 seconds passed without input. Stopping in 10 minutes."
      :timer.sleep(600000)  # 10 minutes
      IO.puts "Program stopped."
    else
      loop(8, last_press_time)
    end
  end

  defp loop(esc_count, last_press_time) do
    case IO.getn("", 1) do
      "\e" ->
        current_time = :os.system_time(:milli_seconds)
        if current_time - last_press_time > 100 do  # Debounce
          new_count = esc_count + 1
          IO.puts "ESC pressed #{new_count} times"
          loop(new_count, current_time)
        else
          loop(esc_count, last_press_time)
        end
      _ ->
        loop(esc_count, last_press_time)
    end
  end
end

EscDetection.start()