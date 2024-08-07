import std/[os, times]

var 
  escCount = 0
  lastKeyTime = epochTime()

proc onExit() {.noconv.} =
  echo "プログラムを終了します"
  quit()

setControlCHook(onExit)

echo "ESCキーを8回押してください"

while true:
  if kbhit():
    let key = getch()
    if key == chr(27):  # ESCキーのASCIIコード
      escCount.inc
      lastKeyTime = epochTime()
      echo "ESCキーが押されました。カウント: ", escCount
      if escCount == 8:
        echo "ESCキーが8回押されました"
        echo "3秒間何も押さないでください"
        sleep(3000)
        echo "3秒間経過しました"
        echo "プログラムは10分間停止します"
        sleep(600000)  # 10分 = 600,000ミリ秒
        quit()
    else:
      escCount = 0
  elif epochTime() - lastKeyTime > 3.0:
    echo "3秒間キー入力がありませんでした"
    lastKeyTime = epochTime()
  
  sleep(100)  # CPUの負荷を下げるために少し待機8