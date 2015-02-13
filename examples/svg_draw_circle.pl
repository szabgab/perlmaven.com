#!/usr/bin/perl
use strict;
use warnings;

use SVG;

# create an SVG object with a size of 40x40 pixels
my $svg = SVG->new(
    width  => 40,
    height => 40,
);

# add a circle
$svg->circle(
    cx => 20,
    cy => 20,
    r  => 18,
);


# now render the SVG object, implicitly use svg namespace
print $svg->xmlify;

