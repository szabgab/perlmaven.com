#!/usr/bin/perl
use strict;
use warnings;

use SVG;
 
my $app = sub {
    my $svg = SVG->new(
        width  => 200,
        height => 200,
    );
    $svg->title()->cdata('I am a title');

    # add a circle
    my $red = $svg->circle(
        cx => 100,
        cy => 100,
        r  => 50,
        id => 'red_circle',
        style => {
            'fill'         => '#FF0000',
            'fill-opacity' => 0.5,
        }
    );

    my $blue = $svg->circle(
        cx => 150,
        cy => 100,
        r  => 50,
        id => 'blue_circle',
        style => {
            'fill'         => '#0000FF',
            'fill-opacity' => 0.5,
        }
    );

    my $green = $svg->circle(
        cx => 125,
        cy => 150,
        r  => 50,
        id => 'green_circle',
        style => {
            'fill'         => '#00FF00',
            'fill-opacity' => 0.5,
        }
    );


    return [
        '200',
        [ 'Content-Type' => 'image/svg+xml' ],
        [ $svg->xmlify ],
    ];
};


