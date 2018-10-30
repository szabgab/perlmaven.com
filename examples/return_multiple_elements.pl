use strict;
use warnings;
use Data::Dumper qw(Dumper);

sub compute {
    my ($x, $y) = @_;

    my $add      = $x + $y;
    my $multiply = $x * $y;
    my $subtract = $x - $y;
    my $divide   = $x / $y;

    return $add, $multiply, $subtract, $divide;
}


my @result = compute(42, 2);
print Dumper \@result;

my ($sum, $mul, $sub, $div) = compute(102, 3);
print "sum: $sum\n";
print "mul: $mul\n";
print "sub: $sub\n";
print "div: $div\n";
