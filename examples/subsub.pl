use strict;
#use warnings;

print sum(2, 3), "\n";
print sum(2, 3, 4), "\n";

sub sum {
    my $sum = 0;
    $sum += $_ for @_;
    return $sum;
}

# ... after many hundreds of lines of code

sub sum {
    my ($x, $y) = @_;

    return $x + $y;
}


