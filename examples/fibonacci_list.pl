use 5.010;
use strict;
use warnings;
use Data::Dumper;

sub fibonacci {
    my ($n) = @_;
    if ($n == 1) {
        return 1;
    }
    if ($n == 2) {
        return 1, 1;
    }
    my @fib = (1, 1);
    for (2 .. $n) {
        push @fib, $fib[-1] + $fib[-2];
    }
    return @fib;
}

my @results = fibonacci(8);
print Dumper \@results;

my ($first, $second, @rest) = fibonacci(6);
print "first: $first\n";
print "second: $second\n";
print Dumper \@rest;

