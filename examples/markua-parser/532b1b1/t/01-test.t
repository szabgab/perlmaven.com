use strict;
use warnings;

use Test::More;
use Markua::Parser;

plan tests => 1;

my $m = Markua::Parser->new;
isa_ok $m, 'Markua::Parser';

