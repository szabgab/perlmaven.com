#use v5.44;
use v5.38;
use feature 'class';
no warnings 'experimental::class';

class Point {
    field $x :param;
    field $y :param;

    ADJUST {
        # This is called after the instance was created and the attributes were populated
        $y = 23;
        #$y += 23;
    }

    method stringify {
        return "($x, $y)";
    }

}

my $p = Point->new(x => 2, y => 19);
say $p->stringify;

