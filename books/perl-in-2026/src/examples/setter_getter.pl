#use v5.44;
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :reader :writer;
    field $y :reader(get_y) :writer(add_y);
}

my $p = Point->new();
# say $p->x; # Undefined

$p->set_x(10);
say $p->x;

$p->add_y(7);
say $p->get_y;
