use strict;
use warnings;

use Test::More;
use JSON::MaybeXS qw(decode_json);
use Path::Tiny qw(path);
use Markua::Parser;

plan tests => 3;

my $m = Markua::Parser->new;
isa_ok $m, 'Markua::Parser';

my $result = $m->parse_file('t/input/heading1.md');
is_deeply $result, decode_json( path('t/dom/heading1.json')->slurp_utf8 );

$result = $m->parse_file('t/input/headers.md');
is_deeply $result, decode_json( path('t/dom/headers.json')->slurp_utf8 );

