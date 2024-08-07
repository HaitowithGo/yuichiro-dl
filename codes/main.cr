require "io/console"

esc_count = 0
last_key_time = Time.monotonic

puts "ESCキーを8回押してください"

loop do
  if STDIN.raw(&.read_char)
    char = STDIN.raw(&.read_char)
    if char == '\e'
      esc_count += 1
      last_key_time = Time.monotonic
      puts "ESCキーが押されました。カウント: #{esc_count}"
      if esc_count == 8
        puts "ESCキーが8回押されました"
        puts "3秒間何も押さないでください"
        sleep 3
        puts "3秒間経過しました"
        puts "プログラムは10分間停止します"
        sleep 600
        exit
      end
    else
      esc_count = 0
    end
  elsif Time.monotonic - last_key_time > 3.seconds
    puts "3秒間キー入力がありませんでした"
    last_key_time = Time.monotonic
  end

  sleep 0.1
end