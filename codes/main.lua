local luv = require('luv')

local esc_count = 0
local last_press_time = luv.now()

print("Press ESC 8 times, then wait for 3 seconds.")

local stdin = luv.new_tty(0, true)
stdin:read_start(function(err, data)
  if err then
    print("Error: " .. err)
    return
  end

  if data == string.char(27) then  -- 27 is the ASCII code for ESC
    local current_time = luv.now()
    if current_time - last_press_time > 100 then  -- Debounce
      esc_count = esc_count + 1
      print("ESC pressed " .. esc_count .. " times")
      last_press_time = current_time

      if esc_count == 8 then
        print("Waiting for 3 seconds of inactivity...")
        luv.timer_start(luv.new_timer(), 3000, 0, function()
          if luv.now() - last_press_time >= 3000 then
            print("3 seconds passed without input. Stopping in 10 minutes.")
            luv.timer_start(luv.new_timer(), 600000, 0, function()  -- 10 minutes
              print("Program stopped.")
              os.exit()
            end)
          end
        end)
      end
    end
  end
end)

luv.run()