#use v5.44;
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param :reader;
    field $y :param :writer;

    method stringify {
        say "($x, $y)";
    }

    method move($dx, $dy) {
        $x += $dx;
        $y += $dy;
    }
}
my $p = Point->new(x => 2, y => 3);
$p->stringify;
say $p->x;
#say $p->y; # Can't locate object method "y"
$p->set_y(10);

$p->stringify;


$p->move(7, 8);
$p->stringify;

