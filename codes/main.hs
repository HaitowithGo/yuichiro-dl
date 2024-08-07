import System.IO
import Control.Monad (when)
import Data.Time.Clock.POSIX (getPOSIXTime)
import Control.Concurrent (threadDelay)

main :: IO ()
main = do
  hSetBuffering stdin NoBuffering
  hSetEcho stdin False
  putStrLn "Press ESC 8 times, then wait for 3 seconds."
  loop 0 0

loop :: Int -> Double -> IO ()
loop escCount lastPressTime = do
  key <- getChar
  currentTime <- getPOSIXTime
  let timeDiff = realToFrac (currentTime - lastPressTime)
  
  if key == '\ESC' && timeDiff > 0.1 then do
    let newCount = escCount + 1
    putStrLn $ "ESC pressed " ++ show newCount ++ " times"
    if newCount == 8
      then do
        putStrLn "Waiting for 3 seconds of inactivity..."
        threadDelay 3000000  -- 3 seconds
        noInput <- isNoInput
        when noInput $ do
          putStrLn "3 seconds passed without input. Stopping in 10 minutes."
          threadDelay 600000000  -- 10 minutes
          putStrLn "Program stopped."
        when (not noInput) $ loop newCount currentTime
      else loop newCount currentTime
  else loop escCount lastPressTime

isNoInput :: IO Bool
isNoInput = do
  ready <- hReady stdin
  if ready
    then getChar >> return False
    else return True