#use v5.44;
use v5.38;
use feature 'class';
no warnings 'experimental::class';
use Data::Dumper;

class Point {
    field $x;
    field $y;

}
my $p = Point->new();
say $p;
#say Dumper $p;

#my $q = Point->new(x => 2, y => 3);
