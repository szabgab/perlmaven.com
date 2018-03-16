use strict;
use warnings;
use 5.010;

say system "perl script.pl";
say $?;
say $? >> 8;

