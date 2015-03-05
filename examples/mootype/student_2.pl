use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new( name => 'Foo', age => 'old' );
say $student->name;

