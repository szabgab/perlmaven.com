package Person;
use strict;
use warnings;
use 5.010;

$Person::name = 'Jane';
say $Person::name;

our $name;
say $name;

