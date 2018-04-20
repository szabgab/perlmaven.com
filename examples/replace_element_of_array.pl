use strict;
use warnings;

use Data::Dumper;
my @authors = ('Issac Asimov', 'Arthor C. Clarke', 'Ray Bradbury', 'Foo Bar', 'Philip K. Dick', 'H. G. Wells', 'Frank Herbert');

print Dumper \@authors;

$authors[3] = 'Jules Verne';

print Dumper \@authors;

