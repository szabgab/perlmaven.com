#use v5.44;
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param;
    field $y :param;

    method stringify {
        return "($x, $y)";
    }

    method move($dx, $dy) {
        $x += $dx;
        $y += $dy;
    }
}
my $p = Point->new(x => 2, y => 3);
say $p->stringify;

$p->move(7, 8);
say $p->stringify;

