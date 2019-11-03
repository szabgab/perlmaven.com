use strict;
use warnings;
use 5.010;
use DateTime;

say scalar gmtime(0);

say scalar localtime(0);

my $dt = DateTime->from_epoch( epoch => 0 );
say $dt;

my $time = time();
say $time;
say scalar localtime($time);

