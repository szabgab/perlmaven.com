#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);

my $filename = "numbers.txt";
open(my $fh, "<", $filename) or die "Could not open '$filename'\n";
my $sum = sum <$fh>;
print "The total value is $sum\n";

