use 5.010;
use strict;
use warnings;

my @planets = qw(
    Ceres
    Charon
    Earth
    Jupiter
    Mars
    Mercury
    Neptune
    Pluto
    Saturn
    Uranus
    Venus
);

my $name = shift or die "Usage: $0 PLANET";
my $res = linear_search($name, \@planets);
if (not defined $res) {
    say "$name not found";
} else {
    say "$name found at $res";
}

sub linear_search {
    my ($str, $list) = @_;
    for my $i (0 .. @$list -1) {
        if ($list->[$i] eq $str) {
            return $i;
        }
    }
    return;
}

