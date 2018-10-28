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
my $res = binary_search($name, \@planets);
if (not defined $res) {
    say "$name not found";
} else {
    say "$name found at $res";
}

sub binary_search {
    my ($str, $list) = @_;

    my $min = 0;
    my $max = @$list - 1;
    
    while ($min <= $max) {
        my $middle = int(($max+$min) / 2);
        # say "$min - $max ($middle)";
        if ($name lt $list->[$middle]) {
            $max = $middle-1;
            next;
        }
        if ($name gt $list->[$middle]) {
            $min = $middle+1;
            next;
        }
        return $middle;
    }

    return;
}
