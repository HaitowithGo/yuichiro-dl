#include <iostream>
#include <chrono>
#include <thread>
#include <conio.h>

int main() {
    int escCount = 0;
    auto lastPressTime = std::chrono::steady_clock::now();

    std::cout << "Press ESC 8 times, then wait for 3 seconds." << std::endl;

    while (true) {
        if (_kbhit()) {
            int key = _getch();
            if (key == 27) {  // 27 is the ASCII code for ESC
                auto currentTime = std::chrono::steady_clock::now();
                auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime - lastPressTime);
                if (duration.count() > 100) {  // Debounce
                    escCount++;
                    std::cout << "ESC pressed " << escCount << " times" << std::endl;
                    lastPressTime = currentTime;

                    if (escCount == 8) {
                        std::cout << "Waiting for 3 seconds of inactivity..." << std::endl;
                        std::this_thread::sleep_for(std::chrono::seconds(3));
                        if (!_kbhit()) {
                            std::cout << "3 seconds passed without input. Stopping in 10 minutes." << std::endl;
                            std::this_thread::sleep_for(std::chrono::minutes(10));
                            std::cout << "Program stopped." << std::endl;
                            break;
                        }
                    }
                }
            }
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(10));  // Small delay to reduce CPU usage
    }

    return 0;
}