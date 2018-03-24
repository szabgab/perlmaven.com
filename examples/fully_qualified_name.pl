use 5.010;
use strict;

state $x = 42;
say $x;

our $y = 37;
say $y;

use vars qw($z);
$z = 100;
say $z;

$Person::name = 'Foo';
say $Person::name;

