import java.awt.KeyEventDispatcher
import java.awt.KeyboardFocusManager
import java.awt.event.KeyEvent
import kotlin.system.exitProcess

fun main() {
    var escCount = 0
    var lastPressTime = System.currentTimeMillis()

    println("Press ESC 8 times, then wait for 3 seconds.")

    KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher { ke ->
        if (ke.id == KeyEvent.KEY_PRESSED && ke.keyCode == KeyEvent.VK_ESCAPE) {
            val currentTime = System.currentTimeMillis()
            if (currentTime - lastPressTime > 100) {  // Debounce
                escCount++
                println("ESC pressed $escCount times")
                lastPressTime = currentTime

                if (escCount == 8) {
                    println("Waiting for 3 seconds of inactivity...")
                    Thread.sleep(3000)
                    if (System.currentTimeMillis() - lastPressTime >= 3000) {
                        println("3 seconds passed without input. Stopping in 10 minutes.")
                        Thread.sleep(600000)  // 10 minutes
                        println("Program stopped.")
                        exitProcess(0)
                    }
                }
            }
        }
        false
    }

    // Keep the program running
    while (true) {
        Thread.sleep(100)
    }
}