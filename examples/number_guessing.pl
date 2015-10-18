#!/usr/bin/perl 
use strict;
use warnings;
use v5.10;

my $N = 200;

my $hidden = 1 + int rand $N;

print "Please guess between 1 and $N: ";
my $guess = <STDIN>;
chomp $guess;

if ($guess < $hidden) {
    say "Your guess ($guess) is too small.";
}
if ($guess > $hidden) {
    say "Your guess ($guess) is too big.";
}
if ($guess == $hidden) {
    say "Heureka!";
}

