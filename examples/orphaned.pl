use strict;
use warnings;
use 5.010;


say "In Main: PID: $$ PPID: ", getppid();

my $pid = fork();
if ($pid) {
    say $pid;
    sleep 1;
    say "In Parent: PID: $$ PPID: ", getppid();
    sleep 1;
    exit();
} else {
    say "In Child: PID: $$ PPID: ", getppid();
    sleep 3;
    say "In Child: PID: $$ PPID: ", getppid();
}
