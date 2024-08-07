use strict;
use warnings;
use Time::HiRes qw(time sleep);
use Term::ReadKey;

ReadMode('cbreak');

my $esc_count = 0;
my $last_press_time = time;

print "Press ESC 8 times, then wait for 3 seconds.\n";

while (1) {
    if (defined(my $key = ReadKey(-1))) {
        if (ord($key) == 27) {  # 27 is the ASCII code for ESC
            my $current_time = time;
            if ($current_time - $last_press_time > 0.1) {  # Debounce
                $esc_count++;
                print "ESC pressed $esc_count times\n";
                $last_press_time = $current_time;

                if ($esc_count == 8) {
                    print "Waiting for 3 seconds of inactivity...\n";
                    sleep(3);
                    if (!defined(ReadKey(-1))) {
                        print "3 seconds passed without input. Stopping in 10 minutes.\n";
                        sleep(600);  # 10 minutes
                        print "Program stopped.\n";
                        last;
                    }
                }
            }
        }
    }
    sleep(0.01);  # Small delay to reduce CPU usage
}

ReadMode('normal');