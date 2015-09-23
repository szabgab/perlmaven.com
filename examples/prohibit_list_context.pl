use 5.010;
use strict;
use warnings;
use Data::Dumper qw(Dumper);
use Carp qw(croak);

sub div {
    my ($x, $y) = @_;
    croak 'Cannot use "div" in list context' if wantarray;

    if ($y !=0 ) {
        return $x/$y;
    }
    return;
}

my $x = div(6, 2);
print "$x\n";

my %results = (
    '42/0' => scalar div(42, 0),
    '6/2'  => scalar div(6, 2),
);
print Dumper \%results;


my @y = div(6, 2);


