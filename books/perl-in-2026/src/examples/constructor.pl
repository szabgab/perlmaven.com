#use v5.44;
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param;
    field $y :param;
}
my $p = Point->new(x => 2, y => 3);

say $p;

