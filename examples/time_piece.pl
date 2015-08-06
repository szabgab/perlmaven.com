use 5.010;
use strict;
use warnings;
use Time::Piece;


my @dates = ("3 Nov, 1989", "Nov, 1989", "1 Jan, 1999");

foreach my $d (@dates) {
    my $tp = Time::Piece->strptime($d, "%d %b, %Y");
    say $tp;
}
