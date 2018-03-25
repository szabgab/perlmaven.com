use strict;
use warnings;
use Data::Dumper qw(Dumper);

my %phone_of = (
    'Foo' => '1112222',
    'Bar' => '3334444',
    'Qux' => '5556666',
);

my %owner_of = reverse %phone_of; 
print Dumper \%owner_of;

