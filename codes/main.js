const readline = require('readline');

readline.emitKeypressEvents(process.stdin);
process.stdin.setRawMode(true);

let escCount = 0;
let lastPressTime = Date.now();

console.log("Press ESC 8 times, then wait for 3 seconds.");

process.stdin.on('keypress', (str, key) => {
  if (key.name === 'escape') {
    const currentTime = Date.now();
    if (currentTime - lastPressTime > 100) {  // Debounce
      escCount++;
      console.log(`ESC pressed ${escCount} times`);
      lastPressTime = currentTime;

      if (escCount === 8) {
        console.log("Waiting for 3 seconds of inactivity...");
        setTimeout(() => {
          if (Date.now() - lastPressTime >= 3000) {
            console.log("3 seconds passed without input. Stopping in 10 minutes.");
            setTimeout(() => {
              console.log("Program stopped.");
              process.exit();
            }, 600000);  // 10 minutes
          }
        }, 3000);
      }
    }
  } else if (key.ctrl && key.name === 'c') {
    process.exit();
  }
});