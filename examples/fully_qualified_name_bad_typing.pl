use 5.010;
use strict;
use warnings;

$Perlson::name = 'Moo';

$Person::name = 'Foo';
$Person::name = 'Bar';

say $Perlson::name;
