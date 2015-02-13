#!/usr/bin/perl
use strict;
use warnings;
  
use SVG;
  
# create an SVG object with a size of 100x100 pixels
my $svg = SVG->new(
    width  => 100,
    height => 100,
);
  
# create a rectangle (actually square) with the top left
# corner being at (40, 50)
# (0, 0) would mean being in the top left corner of the image.
# The width and the height of the rectangular are also given
# in pixels and we can add style just asw we  did with the circle.
$svg->rectangle(
    x => 40,
    y => 50,
    width  => 40,
    height => 40,
    style => {
        'fill'           => 'rgb(0, 255, 0)',
        'stroke'         => 'black',
        'stroke-width'   =>  0,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,
    },
);

$svg->circle(
    cx => 40,
    cy => 40,
    r  => 20,
    style => {
        'fill'           => 'rgb(255, 0, 0)',
        'stroke'         => 'black',
        'stroke-width'   =>  0,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,
    },
);

# In order to create a triangle we are going to create a polygon
# To make it easy to create various path based constructs, SVG.pm
# provides a "get_path" method that, give a series of coordinates
# and a type, return the respective data structure that is needed
# for SVG.
my $path = $svg->get_path(
    x => [40, 60, 80],
    y => [40, 6, 40],
    -type => 'polygon');

# Then we use that data structure to create a polygon
$svg->polygon(
    %$path,
    style => {
        'fill'           => 'rgb(0,0,255)',
        'stroke'         => 'black',
        'stroke-width'   =>  0,
        'stroke-opacity' =>  1,
        'fill-opacity'   =>  1,
    },
);

# now render the SVG object, implicitly use svg namespace
print $svg->xmlify;

