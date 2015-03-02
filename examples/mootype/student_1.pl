use strict;
use warnings;
use 5.010;

use Person;
my $student = Person->new( name => 'Foo', age => 22 );
say $student->name;
say $student->age;
$student->age('young');
say $student->age;

