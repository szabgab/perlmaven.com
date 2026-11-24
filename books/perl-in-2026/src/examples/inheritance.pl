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

class Circle :isa(Point) {
    field $r :param;

    method area() {
        return $r * $r * 3.14;
    }

    #    method move($dx, $dy) {
    #        say "before move the circle";
    #        $self->SUPER::move($dx, $dy);
    #        say "after move the circle";
    #    }
}

my $c = Circle->new(x => 2, y => 3, r => 10);
say $c->stringify;

say $c->area;

$c->move(7, 8);
say $c->stringify;


