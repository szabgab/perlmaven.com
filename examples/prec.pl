use strict;
#use warnings;

my $resa = compute(23);
print "$resa\n";

my $resb = compute(0);
print "$resb\n";

sub compute {
    my ($param) = @_;

    # ...
    return $param or 42;
}
