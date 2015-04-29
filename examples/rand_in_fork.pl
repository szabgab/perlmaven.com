use strict;
use warnings;
use 5.010;

#say "Parent $$ generated " . rand();
my $n = 3;
for (1 .. $n) {
    my $pid = fork();
    if (not $pid) {
       srand();
       say "Child  $$ generated " . rand();
       exit;
    }
}

for (1 .. $n) {
   wait();
}

