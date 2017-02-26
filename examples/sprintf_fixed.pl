use strict;
use warnings;

my $line = '51.72';

$line =~ s/(\d{2}\.\d{2}\b)/sprintf("%4.1f", $1)/e;

print $line;

