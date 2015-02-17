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
        #style => {
        #    'fill'         => '#FF0000',
        #    #'fill-opacity' => 0.5,
        #}
    );

    return [
        '200',
        [ 'Content-Type' => 'image/svg+xml' ],
        [ $svg->xmlify ],
    ];
};

