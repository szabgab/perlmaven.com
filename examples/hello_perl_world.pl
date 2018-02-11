use 5.010;
use strict;
use warnings;

my $str = "Hello Perl World";
my $part = substr $str, 6, 4;
say qq('$part');

my $other = substr $str, 11, 10;
say qq('$other');


my $more = substr $str, 20, 10;

