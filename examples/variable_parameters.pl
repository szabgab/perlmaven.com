#!/usr/bin/perl
use strict;
use warnings;
use 5.010;

say sum(3, 7, 11, 21);

my @values = (1, 2, 3);
say sum(@values);

sub sum {
    my $sum = 0;
    foreach my $v (@_) {
        $sum += $v;
    }
    return $sum;
}

