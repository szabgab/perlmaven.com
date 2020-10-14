#!/usr/bin/env perl
 
use strict;
use warnings;
 
use File::Spec;
 
use GraphViz2;
use GraphViz2::Parse::ISA;
 
my($graph) = GraphViz2 -> new
        (
         edge   => {color => 'grey'},
         global => {directed => 1},
         graph  => {rankdir => 'BT'},
         node   => {color => 'blue', shape => 'Mrecord'},
        );
my($parser) = GraphViz2::Parse::ISA -> new(graph => $graph);
 
unshift @INC, 't/lib';
 
$parser -> add(class => 'Adult::Child::Grandchild', ignore => []);
#$parser -> add(class => 'Hybrid', ignore => []);
$parser -> generate_graph;
 
my($format)      = shift || 'svg';
#my($output_file) = shift || File::Spec -> catfile('html', "parse.code.$format");
my($output_file) = shift || "parse.code.$format";
 
$graph -> run(format => $format, output_file => $output_file);
