use strict;
use warnings;
use 5.010;

my $dir = shift // '.';

opendir my $dh, $dir or die "Could not open '$dir' for reading '$!'\n";
my @things = grep {$_ ne '.' and $_ ne '..'} readdir $dh;
foreach my $thing (@things) {
    say $thing;
}
closedir $dh;


