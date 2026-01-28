use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %counter;
print Dumper \%counter;
$counter{Foo}++;
print Dumper \%counter;

