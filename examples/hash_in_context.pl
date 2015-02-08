use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

my %color_of = (
    apple  => 'red',
    grape  => 'purple',
    banana => 'yellow',
);

my @pairs = %color_of;
my $var = %color_of;

say Dumper \%color_of;
say Dumper \@pairs;
say $var;
