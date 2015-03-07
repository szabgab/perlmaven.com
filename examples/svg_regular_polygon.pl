use strict;
use warnings;
use 5.010;

use SVG;
use Math::Trig qw(:pi);

say create();

sub create {
    my $svg = SVG->new(
        width  => 120,
        height => 120,
    );

    my $n = 9;       # number of nodes
    my $r = 50;      # radius
    my $sr = 0;      # starting degree in radians
    my $cx = 60;     # center x 
    my $cy = 60;     # center y
    my @x;
    my @y;
    for my $i (1 .. $n) {
        push @x, $cx + $r * sin($sr + ($i * pi2 / $n)); 
        push @y, $cy + $r * cos($sr + ($i * pi2 / $n));
    }
    my $lt = $svg->polygon(
        %{ $svg->get_path(
            x => \@x,
            y => \@y,
            -type   => 'polygon',
            -closed  => 'true'
        )},
        style => {
            'fill-opacity' => 1,
            'fill'         => '#FF0000',
            'stroke'       => '#999',
            'stroke-width' => 1,
        },
    );

    return $svg->xmlify;
}

