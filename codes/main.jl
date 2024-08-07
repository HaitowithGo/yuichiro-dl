using Dates

function read_key()
    return read(stdin, Char)
end

function main()
    esc_count = 0
    last_key_time = now()

    println("ESCキーを8回押してください")

    while true
        if isready(stdin)
            key = read_key()
            if key == '\e'
                esc_count += 1
                last_key_time = now()
                println("ESCキーが押されました。カウント: $esc_count")
                if esc_count == 8
                    println("ESCキーが8回押されました")
                    println("3秒間何も押さないでください")
                    sleep(3)
                    println("3秒間経過しました")
                    println("プログラムは10分間停止します")
                    sleep(600)
                    exit()
                end
            else
                esc_count = 0
            end
        elseif (now() - last_key_time).value > 3000
            println("3秒間キー入力がありませんでした")
            last_key_time = now()
        end

        sleep(0.1)
    end
end

main()