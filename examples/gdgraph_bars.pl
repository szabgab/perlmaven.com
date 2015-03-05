use strict;
use warnings;

use GD::Graph::bars;
use GD::Graph::Data;

my $data = GD::Graph::Data->new([
    ["1st","2nd","3rd","4th","5th","6th","7th", "8th", "9th"],
    [    1,    2,    5,    6,    3,  1.5,    1,     3,     4],
]) or die GD::Graph::Data->error;


my $graph = GD::Graph::bars->new;

$graph->set( 
    x_label         => 'X Label',
    y_label         => 'Y label',
    title           => 'A Simple Bar Chart',

    #y_max_value     => 7,
    #y_tick_number   => 8,
    #y_label_skip    => 3,

    #x_labels_vertical => 1,

    #bar_spacing     => 10,
    #shadow_depth    => 4,
    #shadowclr       => 'dred',

    #transparent     => 0,
) or die $graph->error;

$graph->plot($data) or die $graph->error;

my $file = 'bars.png';
open(my $out, '>', $file) or die "Cannot open '$file' for write: $!";
binmode $out;
print $out $graph->gd->png;
close $out;

