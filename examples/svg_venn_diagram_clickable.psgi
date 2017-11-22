#!/usr/bin/perl
use strict;
use warnings;

# run this example using plackup -r examples/svg.psgi

use SVG;
 
my $app = sub {
    my $svg = SVG->new(
        width  => 200,
        height => 200,
    );
    $svg->title()->cdata('I am a title');

    my $red_tag = $svg->anchor(
        -href => 'http://perlmaven.com/'
    );
    my $red = $red_tag->circle(
        cx => 100,
        cy => 100,
        r  => 50,
        id => 'red_circle',
        style => {
            'fill'         => '#FF0000',
            'fill-opacity' => 0.5,
        }
    );

    my $blue_tag = $svg->anchor(
        -href => 'http://code-maven.com/'
    );
    my $blue = $blue_tag->circle(
        cx => 150,
        cy => 100,
        r  => 50,
        id => 'blue_circle',
        style => {
            'fill'         => '#0000FF',
            'fill-opacity' => 0.5,
        }
    );

    my $green_tag = $svg->anchor(
        -href => 'http://perl6maven.com/'
    );
    my $green = $green_tag->circle(
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


