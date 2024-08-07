import java.awt.KeyEventDispatcher
import java.awt.KeyboardFocusManager
import java.awt.event.KeyEvent
import scala.concurrent.{Future, ExecutionContext}
import scala.concurrent.duration._
import java.util.concurrent.Executors

object EscDetection extends App {
  implicit val ec: ExecutionContext = ExecutionContext.fromExecutor(Executors.newSingleThreadExecutor())

  var escCount = 0
  var lastPressTime = System.currentTimeMillis()

  println("Press ESC 8 times, then wait for 3 seconds.")

  KeyboardFocusManager.getCurrentKeyboardFocusManager.addKeyEventDispatcher(new KeyEventDispatcher {
    override def dispatchKeyEvent(ke: KeyEvent): Boolean = {
      if (ke.getID == KeyEvent.KEY_PRESSED && ke.getKeyCode == KeyEvent.VK_ESCAPE) {
        val currentTime = System.currentTimeMillis()
        if (currentTime - lastPressTime > 100) {  // Debounce
          escCount += 1
          println(s"ESC pressed $escCount times")
          lastPressTime = currentTime

          if (escCount == 8) {
            println("Waiting for 3 seconds of inactivity...")
            Future {
              Thread.sleep(3000)
              if (System.currentTimeMillis() - lastPressTime >= 3000) {
                println("3 seconds passed without input. Stopping in 10 minutes.")
                Thread.sleep(600000)  // 10 minutes
                println("Program stopped.")
                System.exit(0)
              }
            }
          }
        }
      }
      false
    }
  })

  // Keep the program running
  while (true) {
    Thread.sleep(100)
  }
}