#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(sum);
use Path::Tiny qw(path);

my $filename = "numbers.txt";
my $sum = sum path($filename)->lines;
print "The total value is $sum\n";

