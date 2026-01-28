use strict;
use warnings;

use Data::Dumper qw(Dumper);

my %people;

print Dumper \%people;
$people{Foo}{phone} = '123-456';
print Dumper \%people;

