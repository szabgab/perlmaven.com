use strict;
use warnings;

use Test::MockTime qw(set_absolute_time restore_time set_fixed_time);
use Test::More;

use MyDaily qw(message);

diag "Normal time: ", time;

# Sets the clock that will move forward at a normal pace
set_absolute_time('1970-03-01T03:00:00Z');
diag "Absolute time: ", time;
is message(), 'Welcome to Perl';
sleep(2);
diag "Time moves forward: ", time;

# Sets the clock that will be fixed on that second
set_fixed_time('1970-04-01T03:00:00Z');
is message(), 'Welcome to Python';
diag "Fixed time: ", time;
sleep(2);
diag "Time is fixed: ", time;

restore_time();
diag "Back to now: ", time;

done_testing;
