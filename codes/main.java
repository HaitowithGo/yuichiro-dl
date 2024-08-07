import java.awt.KeyEventDispatcher;
import java.awt.KeyboardFocusManager;
import java.awt.event.KeyEvent;

public class EscDetection {
    private static int escCount = 0;
    private static long lastPressTime = System.currentTimeMillis();

    public static void main(String[] args) {
        System.out.println("Press ESC 8 times, then wait for 3 seconds.");

        KeyboardFocusManager.getCurrentKeyboardFocusManager().addKeyEventDispatcher(new KeyEventDispatcher() {
            @Override
            public boolean dispatchKeyEvent(KeyEvent ke) {
                if (ke.getID() == KeyEvent.KEY_PRESSED && ke.getKeyCode() == KeyEvent.VK_ESCAPE) {
                    long currentTime = System.currentTimeMillis();
                    if (currentTime - lastPressTime > 100) {  // Debounce
                        escCount++;
                        System.out.println("ESC pressed " + escCount + " times");
                        lastPressTime = currentTime;

                        if (escCount == 8) {
                            System.out.println("Waiting for 3 seconds of inactivity...");
                            new Thread(() -> {
                                try {
                                    Thread.sleep(3000);
                                    if (System.currentTimeMillis() - lastPressTime >= 3000) {
                                        System.out.println("3 seconds passed without input. Stopping in 10 minutes.");
                                        Thread.sleep(600000);  // 10 minutes
                                        System.out.println("Program stopped.");
                                        System.exit(0);
                                    }
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }
                            }).start();
                        }
                    }
                }
                return false;
            }
        });

        // Keep the program running
        while (true) {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}