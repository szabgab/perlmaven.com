use strict;
use warnings;
use 5.010;

use Greeting;

my $g = Greeting->new;

say 'Hi';
$g->welcome('Foo', 'Bar');
say 'Bye';

