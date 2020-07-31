package Person;
use Moo;
has children => (is => 'rw', default => {});


package main;
use strict;
use warnings;
use 5.010;

#use Person;

my $joe = Person->new;
say $joe->children;

my $pete = Person->new;
say $pete->children;

