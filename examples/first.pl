use strict;
use warnings;
use 5.010;
use List::Util qw(first);

my @animals = ('snake', 'camel', 'etruscan shrew', 'ant', 'hippopotamus', 'giraffe');

my $first_with_first = first { length($_) > 5 } @animals;
say $first_with_first;
