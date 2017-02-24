use strict;
#use warnings;

in_range(5);
in_range(6);

sub in_range {
    my ($x) = @_;

    if ($x & $x > 3) {
        print "In range\n";
    } else {
        print "Out of range\n";
    }
}
